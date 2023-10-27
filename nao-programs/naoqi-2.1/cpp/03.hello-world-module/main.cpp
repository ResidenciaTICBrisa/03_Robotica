#include <iostream>

#include <alcommon/albroker.h>

#include "helloworldmodule.hpp"

int main(int argc, char **argv)
{
	if (argc != 3) {
		std::cerr << "Please inform NAO's IP and port" << std::endl;
		exit(1);
	}

	std::string naoIp = argv[1];
	const int naoPort = std::strtol(argv[2], NULL, 10);

	std::string brokerName = "mybroker";
	std::string brokerIp = "0.0.0.0";
	const int brokerPort = 9560;

	boost::shared_ptr<AL::ALBroker> broker =
		AL::ALBroker::createBroker(brokerName, brokerIp, brokerPort,
		naoIp, naoPort);
	/*
	 * We must obtain the session from the broker as NAOqi 2.1's
	 * implementation of `qi::ApplicationSession(argc, argv)` is broken due
	 * to boost problems
	 */
	qi::SessionPtr session = broker->session();

	// Create an object and register it in the session as a module/service
	session->registerService("HelloWorldModule",
		qi::AnyObject(boost::make_shared<HelloWorldModule>(broker)));

	// Retrieve the module/dervice object from the session
	qi::AnyObject helloWorldModule = session->service("HelloWorldModule");

	// Run a method from the retrieved object using a templated call
	helloWorldModule.call<void>("speakString", "Hello, World!");

	return 0;
}
