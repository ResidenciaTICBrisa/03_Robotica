#include <iostream>
#include <alerror/alerror.h>
#include <alproxies/altexttospeechproxy.h>

int main(int argc, char **argv)
{
	if (argc != 3) {
		std::cout << "Please inform NAO IP and port" << std::endl;
		exit(1);
	}

	const std::string phrase = "Hello, World!";

	try {
		AL::ALTextToSpeechProxy tts(argv[1], std::strtol(argv[2], NULL, 10));
		tts.say(phrase);
	} catch(const AL::ALError& e) {
		std::cerr << e.what() << std::endl;
		exit(2);
	}

	return 0;
}
