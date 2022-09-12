cmake_minimum_required(VERSION 3.10)

# set the project name
project(cpp_mqtt)

include_directories(include)

# add the executable
add_executable(hello src/main.cpp)
