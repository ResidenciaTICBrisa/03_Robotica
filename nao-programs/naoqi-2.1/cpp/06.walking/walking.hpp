#ifndef WALKING_HPP
#define WALKING_HPP

#include <boost/shared_ptr.hpp>

#include <alcommon/albroker.h>

#include <althread/almutex.h>

#include <alvalue/alvalue.h>

#include <alproxies/almemoryproxy.h>
#include <alproxies/alrobotpostureproxy.h>
#include <alproxies/alnavigationproxy.h>
#include <alproxies/almotionproxy.h>
#include <alproxies/altouchproxy.h>
#include <alproxies/altexttospeechproxy.h>

class Walking {
	public:
		typedef void (Walking::*eventCallbackHandlerPtr)(const AL::ALValue &value, const AL::ALValue &message);
		typedef std::map<std::string, eventCallbackHandlerPtr> eventCallbackHandlerMap;
		typedef void (Walking::*eventCallbackPtr)(const std::string &key, const AL::ALValue &value, const AL::ALValue &message);
		typedef std::map<std::string, eventCallbackPtr> eventCallbackMap;

		Walking(boost::shared_ptr<AL::ALBroker> b);
		~Walking();

		static const std::string moduleName;
		static const std::string eventCallbackName;
		static const std::string criticalEventCallbackName;

		void eventCallback(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void criticalEventCallback(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void stop();
		void start();
	private:
		static const float PI;
		boost::shared_ptr<AL::ALBroker> broker;
		boost::shared_ptr<AL::ALMutex> eventCallbackMutex;
		boost::shared_ptr<AL::ALMutexRW> stateMutex;

		static const std::string frontTactilEventKey;
		static const std::string middleTactilEventKey;
		static const std::string postureChangeEventKey;

		static const std::string fsmNextStateEventKey;
		static const std::string fsmCriticalEventKey;

		AL::ALMemoryProxy memoryProxy;
		AL::ALRobotPostureProxy postureProxy;
		AL::ALNavigationProxy navigationProxy;
		AL::ALMotionProxy motionProxy;
		AL::ALTouchProxy touchProxy;
		AL::ALTextToSpeechProxy ttsProxy;

		eventCallbackMap eventCallbacks;

		void subscribe(const std::string key,
			const eventCallbackPtr callback,
			const std::string callbackName);
		void unsubscribe(const std::string key);
		void unsubscribeAll();


		eventCallbackPtr state;

		eventCallbackPtr getState();
		void setState(eventCallbackPtr newState);

		void initialState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void standUpState0(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void standUpState1(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void wakeUpState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void walkLeftState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void walkUpState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void crouchState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void errorState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
		void finalState(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
};

#endif
