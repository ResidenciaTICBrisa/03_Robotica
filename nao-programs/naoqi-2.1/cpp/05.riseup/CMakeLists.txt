cmake_minimum_required(VERSION 2.8)
project(riseup)

find_package(qibuild)

# Create a executable named riseup
# with the source file: main.cpp
qi_create_bin(riseup SRC "main.cpp" "riseup.hpp" "riseup.cpp"  DEPENDS QI BOOST)

# Add a simple test:
#qi_create_test(test_riseup "test.cpp")

qi_use_lib(riseup ALCOMMON ALPROXIES ALTHREAD)
