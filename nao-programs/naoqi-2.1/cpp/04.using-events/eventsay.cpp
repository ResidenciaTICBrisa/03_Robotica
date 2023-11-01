#include <iostream>
#include <algorithm>

#include <boost/shared_ptr.hpp>

#include <alcommon/alproxy.h>
#include <alcommon/albroker.h>

#include <alproxies/almemoryproxy.h>
#include <alvalue/alvalue.h>

#include <althread/alcriticalsection.h>

#include "eventsay.hpp"

// Initialising a functor class, as C++98 lacks support for lambdas
EventSay::unsubscribe_functor::unsubscribe_functor(EventSay e) : eventSay(e) {}
// A functor class must implement an `operator()` with the appropriate type
void EventSay::unsubscribe_functor::operator()(std::string s) const
{
	eventSay.unsubscribe(s);
}

const std::string EventSay::moduleName = "EventSay";

EventSay::EventSay(boost::shared_ptr<AL::ALBroker> b) : broker(b),
	alMemory(AL::ALMemoryProxy(b)),
	callbackMutex(AL::ALMutex::createALMutex()) {}

EventSay::~EventSay()
{
	// Instante the functor passing a pointer to EventSay
	unsubscribe_functor unsubscribe_lambda = unsubscribe_functor(*this);
	/*
	 * A method that loops over a Container and runs the functor on each
	 * element
	 */
	std::for_each(subscribedEvents.begin(), subscribedEvents.end(),
		unsubscribe_lambda);
}

void EventSay::subscribe(const std::string eventName)
{
	alMemory.subscribeToEvent(eventName, moduleName, "eventCallback");
	subscribedEvents.push_back(eventName);
	std::cout << "Subscribed to: " << eventName << std::endl;
}

void EventSay::unsubscribe(const std::string eventName)
{
	alMemory.unsubscribeToEvent(eventName, moduleName);
	// standard C++ to remove an element from a array-like container
	subscribedEvents.erase(
		std::remove(subscribedEvents.begin(), subscribedEvents.end(),
			eventName),
		subscribedEvents.end());
	std::cout << "Unsubscribed to: " << eventName << std::endl;
}

void EventSay::eventCallback(const std::string &key, const AL::ALValue &value,
	const AL::ALValue &message)
{
	// Avoid a multiple trigger scenario
	unsubscribe(key);

	/*
	 * The Aldebaran-provided method to use their custom mutexes, as using
	 * boost::thread and boost::mutex breaks the serialisation needed to
	 * register the object in the broker.
	 * The mutex is locked when a AL::ALCriticalSection object is created
	 * using the AL::ALMutex created.
	 * The ALMutex is unlocked when the ALCriticalSection object is
	 * destroyed
	 */
	AL::ALCriticalSection section(callbackMutex);

	std::cout << "key: " << key << '\n';
	std::cout << "value: " << value << '\n';
	std::cout << "message: " << message << std::endl;

	subscribe(key);
}

QI_REGISTER_MT_OBJECT(EventSay, subscribe, unsubscribe, eventCallback);
