#ifndef HELLO_WORLD_MODULE_H
#define HELLO_WORLD_MODULE_H

#include <iostream>
#include <alcommon/albroker.h>

/*
 * Interface file for a Hello World module
 * The module uses the nw approach introduced in NAOqi 2 that does not require
 * inheriting `public AL::ALModule` and overriding its constructors,
 * virtual destructors or virtual init
 */
class HelloWorldModule
{
	public:
		/*
		 * We will need a valid broker object to initialise our
		 * attribute and be abe to search the services offered by the
		 * broker
		 */
		HelloWorldModule(boost::shared_ptr<AL::ALBroker> b);

		/*
		 * Says the string using the TTS service provided by the broker
		 * It could be implemented using the newer Session object
		 */
		void speakString(std::string phrase);

	private:
		// Broker pointer used to search the TTS service
		boost::shared_ptr<AL::ALBroker> broker;
};

#endif
