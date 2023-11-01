#include <iostream>

#include <cmath>

#include <althread/alcriticalsection.h>
#include <althread/alcriticalsectionread.h>
#include <althread/alcriticalsectionwrite.h>

#include "walking.hpp"

const float Walking::PI = std::acos(-1.0f);

const std::string Walking::moduleName = "Walking";
const std::string Walking::eventCallbackName = "eventCallback";
const std::string Walking::criticalEventCallbackName = "criticalEventCallback";

const std::string Walking::frontTactilEventKey = "FrontTactilTouched";
const std::string Walking::middleTactilEventKey = "MiddleTactilTouched";
const std::string Walking::postureChangeEventKey = "PostureChanged";

const std::string Walking::fsmNextStateEventKey = "WalkingFSMNextState";
const std::string Walking::fsmCriticalEventKey = "WalkingFSMCriticalEvent";

Walking::Walking(boost::shared_ptr<AL::ALBroker> b) : broker(b),
	memoryProxy(AL::ALMemoryProxy(b)),
	postureProxy(AL::ALRobotPostureProxy(b)),
	navigationProxy(AL::ALNavigationProxy(b)),
	motionProxy(AL::ALMotionProxy(b)),
	touchProxy(AL::ALTouchProxy(b)),
	ttsProxy(AL::ALTextToSpeechProxy(b)),
	eventCallbackMutex(AL::ALMutex::createALMutex()),
	stateMutex(AL::ALMutexRW::createALMutexRW())
{
	motionProxy.setSmartStiffnessEnabled(true);
	motionProxy.setExternalCollisionProtectionEnabled("All", true);
	motionProxy.setFallManagerEnabled(true);
	motionProxy.setCollisionProtectionEnabled("Arms", true);
	motionProxy.setDiagnosisEffectEnabled(true);
}

Walking::~Walking()
{
	unsubscribeAll();
}

Walking::eventCallbackPtr Walking::getState()
{
	AL::ALCriticalSectionRead section(stateMutex);
	return state;
}

void Walking::setState(Walking::eventCallbackPtr newState)
{
	AL::ALCriticalSectionWrite section(stateMutex);
	std::cout << "setState" << std::endl;
	state = newState;
}

void Walking::start()
{
	std::cout << "start" << std::endl;

	unsubscribeAll();

	memoryProxy.declareEvent(fsmNextStateEventKey);
	memoryProxy.declareEvent(fsmCriticalEventKey);

	subscribe(frontTactilEventKey, &Walking::eventCallback,
		eventCallbackName);
	subscribe(middleTactilEventKey, &Walking::criticalEventCallback,
		criticalEventCallbackName);
	subscribe(postureChangeEventKey, &Walking::eventCallback,
		eventCallbackName);

	subscribe(fsmNextStateEventKey, &Walking::eventCallback,
		eventCallbackName);
	subscribe(fsmCriticalEventKey, &Walking::eventCallback,
		eventCallbackName);

	setState(&Walking::initialState);

	memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
}

void Walking::stop()
{
	std::cout << "stop" << std::endl;

	unsubscribeAll();

	motionProxy.rest();

	setState(&Walking::finalState);
}

void Walking::subscribe(const std::string key,
	const eventCallbackPtr callback, const std::string callbackName)
{
	if (eventCallbacks.count(key)) {
		std::cerr << key << " already subscribed in " << moduleName;
		std::cerr << std::endl;
	} else {
		memoryProxy.subscribeToEvent(key, moduleName, callbackName);
		eventCallbacks[key] =  callback;
		std::cout << moduleName << " subscribed to " << key;
		std::cout << std::endl;
	}
}

void Walking::unsubscribe(const std::string key)
{
	if (eventCallbacks.count(key)) {
		memoryProxy.unsubscribeToEvent(key, moduleName);
		eventCallbacks.erase(key);
		std::cout << moduleName << " unsubscribed to " << key;
		std::cout << std::endl;
	} else {
		std::cerr << moduleName << " has not subscribed to " << key;
		std::cerr << std::endl;
	}
}

void Walking::unsubscribeAll()
{
	for (eventCallbackMap::iterator it = eventCallbacks.begin();
		it != eventCallbacks.end(); it++) {
		unsubscribe(it->first);
	}
}

void Walking::eventCallback(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	AL::ALCriticalSection section(eventCallbackMutex);

	std::cout << "Event triggered\n";
	std::cout << "key: " << key << '\n';
	std::cout << "value: " << value << '\n';
	std::cout << "message: " << message << std::endl;

	if (!key.compare(fsmCriticalEventKey))
		setState(&Walking::errorState);

	eventCallbackPtr currentState = getState();
	(*this.*currentState)(key, value, message);
}

void Walking::criticalEventCallback(const std::string &key,
	const AL::ALValue &value, const AL::ALValue &message)
{
	std::cout << "Critical event triggered\n";
	std::cout << "key: " << key << '\n';
	std::cout << "value: " << value << '\n';
	std::cout << "message: " << message << std::endl;

	unsubscribeAll();
	subscribe(fsmCriticalEventKey, &Walking::eventCallback,
		eventCallbackName);

	motionProxy.rest();

	setState(&Walking::errorState);
	memoryProxy.raiseEvent(fsmCriticalEventKey, key);
}

void Walking::initialState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "initialState" << std::endl;

	if (!key.compare(frontTactilEventKey)) {
		setState(&Walking::standUpState0);
		memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
	}
}

void Walking::standUpState0(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "standUpState0" << std::endl;

	const std::string posture = "StandInit";
	const float speed = 0.5f;

	if (postureProxy.goToPosture(posture, speed)) {
		setState(&Walking::wakeUpState);
	} else {
		setState(&Walking::errorState);
	}
}

void Walking::wakeUpState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "wakeUpState" << std::endl;

	if (!key.compare(postureChangeEventKey)
		&& !postureProxy.getPosture().compare("StandInit")) {
		motionProxy.wakeUp();
		if (motionProxy.robotIsWakeUp()) {
			setState(&Walking::walkLeftState);
			memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
		} else {
			setState(&Walking::errorState);
			memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
		}
	} else {
		setState(&Walking::errorState);
		memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
	}
}

void Walking::walkLeftState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "walkLeftState" << std::endl;
	/*
	 * Distance in meters relative from the robot (FRAME_ROBOT)
	 * X axis is always positive when NAO is walking forward
	 */
	float x = 0.0f;
	/*
	 * Distance in meters relative from the robot (FRAME_ROBOT)
	 * Y axis is always positive when NAO is walking left
	 */
	float y = 0.5f;
	/*
	 * Z axis rotation in radians (-pi to +pi)
	 */
	float theta = 0.0f;

	motionProxy.moveTo(x, y, theta);

	setState(&Walking::crouchState);

	memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
}

void Walking::crouchState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "crouchState" << std::endl;

	const std::string posture = "Crouch";
	const float speed = 0.5f;

	if (!motionProxy.robotIsWakeUp()) {
		setState(&Walking::errorState);
		memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
		return;
	}
	std::cout << "Will crouch" << std::endl;

	if (postureProxy.goToPosture(posture, speed)) {
		setState(&Walking::standUpState1);
	} else {
		setState(&Walking::errorState);
		memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
	}
}

void Walking::standUpState1(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "standUpState1" << std::endl;

	const std::string posture = "StandZero";
	const float speed = 0.5f;

	if (postureProxy.goToPosture(posture, speed)) {
		setState(&Walking::walkUpState);
	} else {
		setState(&Walking::errorState);
	}
}

void Walking::walkUpState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "walkUpState" << std::endl;
	/*
	 * Distance in meters relative from the robot (FRAME_ROBOT)
	 * X axis is always positive when NAO is walking forward
	 */
	float x = 0.5f;
	/*
	 * Distance in meters relative from the robot (FRAME_ROBOT)
	 * Y axis is always positive when NAO is walking left
	 */
	float y = 0.0f;
	/*
	 * Z axis rotation in radians (-pi to +pi)
	 */
	float theta = 0.0f;

	motionProxy.moveTo(x, y, theta);

	setState(&Walking::finalState);

	memoryProxy.raiseEvent(fsmNextStateEventKey, 0);
}

void Walking::finalState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "finalState" << std::endl;

	setState(&Walking::finalState);
}

void Walking::errorState(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	std::cout << "errorState" << std::endl;
}

QI_REGISTER_MT_OBJECT(Walking, start, stop, eventCallback,
	criticalEventCallback);
