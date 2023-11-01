cmake_minimum_required(VERSION 2.8)
project(using-events)

find_package(qibuild)

# Create a executable named using-events
# with the source file: main.cpp
qi_create_bin(using-events SRC main.cpp eventsay.hpp eventsay.cpp DEPENDS QI BOOST)

# Add a simple test:
#qi_create_test(test_using-events "test.cpp")

qi_use_lib(using-events ALCOMMON ALPROXIES ALTHREAD)
