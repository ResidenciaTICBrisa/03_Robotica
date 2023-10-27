cmake_minimum_required(VERSION 2.8)
project(hello-world-legacy)

find_package(qibuild)

# Create a executable named hello-world-legacy
# with the source file: main.cpp
qi_create_bin(hello-world-legacy "main.cpp")

# Add a simple test:
#qi_create_test(test_hello-world-legacy "test.cpp")

qi_use_lib(hello-world-legacy ALCOMMON ALPROXIES)
