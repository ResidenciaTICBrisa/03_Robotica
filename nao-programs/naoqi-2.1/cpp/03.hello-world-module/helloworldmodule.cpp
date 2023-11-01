#include <iostream>

#include <alcommon/alproxy.h>
#include <alcommon/albroker.h>

#include <alproxies/altexttospeechproxy.h>

#include "helloworldmodule.hpp"

HelloWorldModule::HelloWorldModule(boost::shared_ptr<AL::ALBroker> b)
	: broker(b) {}

/*
 * Seeks the TTS module in the broker using its specialised proxy and calls the
 * method that runs TTS on a string
 * The same result could be obtained by searching the module in the broker
 * using a generic proxy and calling the method through a templated call or a
 * hard-coded one
 * It is also possible to use the approach introduced in NAOqi 2: searching the
 * module as a service provided in the Session object, which can be obtained
 * from the broker. The method calls are usually performed using templates in
 * this case
 */
void HelloWorldModule::speakString(std::string phrase)
{
	AL::ALTextToSpeechProxy ttsProxy = AL::ALTextToSpeechProxy(broker);
	ttsProxy.say(phrase);
}

/*
 * Macro to automatically register the object and its methods as a module
 * compatible with manual initialisation. This means that it must be manually
 * called from a main.cpp and it is not compatible with `qicli` or
 * `qi_create_module` as `QI_REGISTER_MODULE` and qi::ModuleBuilder are only
 * available in NAOqi 2.8
 * All method calls will be run in the same thread
 * Multithreaded support requires registering with QI_REGISTER_MT_OBJECT,
 * which assumes that all method calls are thread-safe and may be run in
 * different threads in parallel
 * Both will break if the object contains overloaded methods. In such a case
 * you must register every method manually with the methods from
 * `qi::ObjectTypeBuilder`(`advertiseMethod`, `advertiseSignal`,
 * `advertiseProperty` and `registerType`) and the help from `static_cast` to
 * remove the ambiguities
 */
QI_REGISTER_OBJECT(HelloWorldModule, speakString);
