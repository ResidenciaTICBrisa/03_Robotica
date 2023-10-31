#ifndef RISEUP_H
#define RISEUP_H

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

class RiseUp
{
	public:
		typedef void (RiseUp::*callbackHandlerPtr)(const AL::ALValue &value, const AL::ALValue &message);
		typedef std::map<std::string, callbackHandlerPtr> eventCallbackHandlerMap;
		RiseUp(boost::shared_ptr<AL::ALBroker> b);
		~RiseUp();

		static const std::string moduleName;
		static const std::string eventCallbackName;

		void wakeUp();
		void rest();
		void eventCallback(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);
	private:
		boost::shared_ptr<AL::ALBroker> broker;
		boost::shared_ptr<AL::ALMutex> callbackMutex;

		AL::ALMemoryProxy memoryProxy;
		AL::ALRobotPostureProxy postureProxy;
		AL::ALNavigationProxy navigationProxy;
		AL::ALMotionProxy motionProxy;
		AL::ALTouchProxy touchProxy;
		AL::ALTextToSpeechProxy ttsProxy;

		eventCallbackHandlerMap eventCallbackHandlers;

		float defaultTangentialSecurityDistance;
		float defaultOrthogonalSecurityDistance;

		void subscribe(const std::string key,
			const callbackHandlerPtr callback);
		void unsubscribe(const std::string key);
		void goToBrazilIfPossible();

		void middleHeadTactilCallback(const AL::ALValue &value,
			const AL::ALValue &message);
		void frontHeadTactilCallback(const AL::ALValue &value,
			const AL::ALValue &message);
		void rearHeadTactilCallback(const AL::ALValue &value,
			const AL::ALValue &message);
};

#endif
