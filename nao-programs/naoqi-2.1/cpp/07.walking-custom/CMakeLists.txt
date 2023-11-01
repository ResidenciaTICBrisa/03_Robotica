cmake_minimum_required(VERSION 2.8)
project(walking)

find_package(qibuild)

# Create a executable named walking
# with the source file: main.cpp
qi_create_bin(walking SRC "main.cpp" "walking.hpp" "walking.cpp" DEPENDS QI BOOST)

# Add a simple test:
# qi_create_test(test_walking "test.cpp")

qi_use_lib(walking ALCOMMON ALPROXIES ALTHREAD)
