cmake_minimum_required(VERSION 2.8)
project(hello-world-module)

find_package(qibuild)

# Create a executable named hello-world-module
# with the source file: main.cpp
qi_create_bin(hello-world-module SRC main.cpp helloworldmodule.hpp helloworldmodule.cpp DEPENDS QI BOOST)

# Add a simple test:
#qi_create_test(test_hello-world-module "test.cpp")

qi_use_lib(hello-world-module ALCOMMON ALPROXIES)
