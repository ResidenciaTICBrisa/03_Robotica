#ifndef EVENT_SAY_H
#define EVENT_SAY_H

#include <boost/shared_ptr.hpp>

#include <alcommon/albroker.h>

#include <alproxies/almemoryproxy.h>
#include <alvalue/alvalue.h>

#include <althread/almutex.h>

class EventSay
{
	public:
		// We need a broker object to obtain its published modules
		EventSay(boost::shared_ptr<AL::ALBroker> b);

		~EventSay();
		/*
		 * Unlike Java, where you can 
		 * `class A { static final String s = "s"; }`
		 * C++ uses `static const` to define a class attribute that
		 * cannot have its value modified.
		 * Also, you must declare it as a `static const type name;` in
		 * the .hpp and define it as `const type name = value;` in the 
		 * .cpp. Only integer types are allowed to be declared and
		 * defined in the .hpp.
		 */
		static const std::string moduleName;

		void subscribe(const std::string eventName);

		void unsubscribe(const std::string eventName);

		/*
		 * prints the event's key, value and message
		 * All event callbacks must have the same signature
		 */
		void eventCallback(const std::string &key,
			const AL::ALValue &value, const AL::ALValue &message);

	private:
		EventSay();

		boost::shared_ptr<AL::ALBroker> broker;
		AL::ALMemoryProxy alMemory;
		std::list<std::string> subscribedEvents;
		// the standard boost:mutex broke the built-in serialisation
		boost::shared_ptr<AL::ALMutex> callbackMutex;

		/*
		 * C++98 lacks lambda support, so me must manually define a
		 * functor class that will be instantiated as a functor object
		 * and use the operator to provide the lambda-like behaviour
		 */
		class unsubscribe_functor {
			public:
				unsubscribe_functor(EventSay e);
				void operator()(std::string s) const;
			private:
				EventSay &eventSay;
		};
};
#endif
