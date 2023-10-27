#include <iostream>
#include <cstdio>

#include <boost/shared_ptr.hpp>

#include <alcommon/albroker.h>

#include "eventsay.hpp"

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

	qi::SessionPtr session = broker->session();

	session->registerService(EventSay::moduleName,
		qi::AnyObject(boost::make_shared<EventSay>(broker)));

	qi::AnyObject eventSayModule = session->service(EventSay::moduleName);

	std::string eventName = "FrontTactilTouched";
	eventSayModule.call<void>("subscribe", eventName);

	int quit = 0;

	while (!quit) {
		std::cout << "Quit (1/0)?" << std::endl;
		std::scanf(" %d", &quit);
	}

	broker->shutdown();

	return 0;
}
