cmake_minimum_required(VERSION 3.10)

# set the project name
project(cpp_mqtt)

# add the executable
add_executable(cpp_mqtt src/main.cpp)

target_link_libraries(cpp_mqtt paho-mqttpp3 paho-mqtt3as)

install(TARGETS cpp_mqtt DESTINATION bin)
