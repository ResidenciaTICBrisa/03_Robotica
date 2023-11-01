# NAOqi 2.1 C++ programming examples

These examples may be used to learn how to code the most basic behaviours
using the NAOqi 2.1 C++98 programming interface.

The NAOqi 2.1 Application Programming Interface only supports C++98,
regardless of the compiler used. All the examples were compiled by the GCC
4.8.2 and cmake 2.8.12 available on the repositories of Ubuntu 14.04,
codenamed *trusty* and tested on a NAOH25V40 robot, a NAO v4 with a complete
body including the feet FSRs.

The following examples are included:

- `01.hello-world-legacy`: the most basic hello world example. It uses the
legacy methods that allow calling a module without an explicit broker. The
robot will use its text to speech module, `ALTextToSpeech`, to say the
classic phrase "Hello, World!".
- `02.hello-world`: a hello world example using an explicit broker. This is
the recommended way to call any API-provided module.
- `03.hello-world-module`: a hello world example implemented as a NAOqi 2
module using a broker in its constructor.
- `04.using-events`: an example that exemplifies how to write a module that
will react to events posted by other modules on `ALMemory` using callback
functions and an API-provided mutex implementation. All the events that have
been subscribed by the module will have their key, value and message printed
on the screen.
- `05.riseup`: an example that teaches how to change NAO's posture and to
allow current to be sent on all of its motors to wake it up. The example
also teaches how to enable useful functions, such as current optimisation,
external and self-collision protection, and the defensive stance against
damages caused by a frontal fall. The robot will react to the tactile
buttons on the top of its head:
    - the front button will cause NAO to wake up, changing its current
      posture to stand up on its feet and sending current to all motors in
      order to remain in this position;
    - the middle tactile button will cause NAo to rest, sending it to the
      standard crouching posture and turning off its motors;
    - the rear tactil will toggle a breathing animation while NAO is awaken.
- `06.walking`: this example uses a state machine to make NAO wake up and
walk using a standard gait to its left side and forward. The robot will
start moving when the front tactil button on its head is activated, and
will stop whenever the middle tactil is touched. This example may not work
if your robot has problems with its joints or its feet's force sensitive
resistors (FSRs).
- `07.walking-custom`: this example is roughly the same as before, but it
makes NAO to walk using a custom gait. It also tolerates robots with
problems on their joints or FSRs by checking if the robot has been able to
approach the desired posture. This example also uses the NAOqi's abstraction
to enable the use of the POSIX `sleep` or `msleep` functions.

## How to find the examples

1. Go to [Robo Connection repository](https://github.com/ResidenciaTICBrisa/03_Robotica).

2. Enter the `03_Robotica/nao-programs/naoqi-2.1/cpp/` directory.

3. All the examples should be listed  and separated by their specific folders.

## How to run the examples

1. copy the desired example to your `qibuild` workspace. If you used our
scripts, it should be on `/home/softex/NAO4/workspace`.
2. change the directory to the example you wish to run using the `cd`
command.
3. configure the project's toolchain. If you used our scripts, the command
`qibuild configure -c "$NAOQI_CPP_QIBUILD_CONFIG"`.
4. compile the project with `qibuild make` or `qibuild make --rebuild`.
5. run the compiled program. It will usually be located inside a directory
structure such as `build-${NAOQI_CPP_QIBUILD_CONFIG}/sdk/bin`. Most of the
examples use arguments to set up a broker, and their order is usually NAO's
broker IPv4 or hostname followed by its listening port, usually 9559.
