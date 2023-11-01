#include <iostream>
#include <memory>

#include <alcommon/alproxy.h>
#include <alcommon/albroker.h>

#include <alproxies/altexttospeechproxy.h>

int main(int argc, char **argv)
{

	if (argc != 3) {
		std::cout << "Please inform NAO IP and port" << std::endl;
		exit(1);
	}

	const std::string phrase = "Hello, World!";
	const std::string phraseSpecialized = phrase
		+ " Spoken by the specialised proxy.";
	const std::string phraseGeneric = phrase
		+ " Spoken by a generic proxy.";
	const std::string phraseGenericTemplated = phrase
		+ " Spoken by a generic proxy through a templated call.";

	const std::string naoIp = argv[1];
	const int naoPort = std::strtol(argv[2], NULL, 10);
	
	const std::string brokerName = "mybroker";
	const std::string brokerIp = "0.0.0.0";
	const int brokerPort = 9560;

	// create our broker
	boost::shared_ptr<AL::ALBroker> broker =
		AL::ALBroker::createBroker(brokerName, brokerIp, brokerPort,
		naoIp, naoPort);

	std::cout << "Broker name: " << broker->getName() << std::endl;
	std::cout << "Broker IP: " << broker->getIP() << std::endl;
	std::cout << "Broker port: " << broker->getPort() << std::endl;

	/* Create a specialised proxy for a ALTextToSpeech
	 * These proxies are available for all Aldebaran modules
	 * Some of these modules have optimisations that accelerate the remote
	 * call with if it contains local resources
	 * They also allow for type and method checking on compile time instead
	 * of only allowing the runtime checks like the generic proxies
	 */
	AL::ALTextToSpeechProxy ttsProxy = AL::ALTextToSpeechProxy(broker);
	ttsProxy.say(phraseSpecialized);

	// Now with a generic proxy
	AL::ALProxy genTtsProxy = AL::ALProxy(broker, "ALTextToSpeech");
	genTtsProxy.callVoid("say", phraseGeneric);
	// using templates to match the return type
	genTtsProxy.call<void>("say", phraseGenericTemplated);

	broker->shutdown();

	return 0;
}
