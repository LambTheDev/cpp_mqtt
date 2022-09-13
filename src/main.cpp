#include <iostream>
#include "mqtt/client.h"

class mqtt_callback : public virtual mqtt::callback
{
  public:
    void connection_lost(const std::string& cause) override {
      std::cout << "Connection lost!" << std::endl;
      if (!cause.empty())
        std::cout << "\tcause: " << cause << std::endl;
    }
};

int main(int argc, char* argv[])
{
  mqtt::client client("ssl://mqtt.eclipseprojects.io:8883", "71FC1XgQadueNgaA9ovH");

  mqtt_callback cb;
  client.set_callback(cb);

  auto ssl_options = mqtt::ssl_options_builder()
    .error_handler([](const std::string& msg) {
        std::cerr << "SSL Error: " << msg << std::endl;
    })
    .finalize();

  auto connection_options = mqtt::connect_options_builder()
    .ssl(ssl_options)
    .clean_session()
    .finalize();

  try {
    std::cout << "Connecting..." << std::endl;
    client.connect(connection_options);
    std::cout << "OK." << std::endl;

    std::cout << "Sending message..." << std::endl;
    auto message = mqtt::make_message("71FC1XgQadueNgaA9ovH", "Hello world!");
    message->set_qos(1);
    client.publish(message);
    std::cout << "OK." << std::endl;

    std::cout << "Disconnecting..." << std::endl;
    client.disconnect();
  }
  catch (const mqtt::exception& e) {
    std::cerr << e.what() << std::endl;
    return 1;
  }

  return 0;
}
