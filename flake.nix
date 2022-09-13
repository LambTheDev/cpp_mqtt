{
  description = "C++ MQTT client";

  outputs = { self, nixpkgs }:
  let
    pname = "cpp_mqtt";
    version = "0.9.0";

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    paho_mqtt_c = pkgs.stdenv.mkDerivation {
      pname = "paho_mqtt_c";
      version = "1.3.10";
      src = pkgs.fetchgit {
        url = "https://github.com/eclipse/paho.mqtt.c";
        rev = "v1.3.10";
        sha256 = "sha256-57RuzKr7BcQJZOFnwc9yefUI7uHrXcJGXunI/D05GHA=";
      };
      buildInputs = [
        pkgs.openssl
      ];
      nativeBuildInputs = [
        pkgs.cmake
      ];
      configurePhase = "true";
      buildPhase = "cmake -Bbuild -H. -DPAHO_ENABLE_TESTING=OFF -DPAHO_WITH_SSL=ON -DPAHO_HIGH_PERFORMANCE=ON -DCMAKE_INSTALL_PREFIX=$out";
      installPhase = "cmake --build build/ --target install";
    };

    paho_mqtt_cpp = pkgs.stdenv.mkDerivation {
      pname = "paho_mqtt_cpp";
      version = "1.3.10";
      src = pkgs.fetchgit {
        url = "https://github.com/eclipse/paho.mqtt.cpp";
        rev = "v1.2.0";
        sha256 = "sha256-tcq0a4X5dKE4rnczRMAVe3Wt43YzUKbxsv9Sk+q+IB8=";
      };
      buildInputs = [
        pkgs.openssl
        paho_mqtt_c
      ];
      nativeBuildInputs = [
        pkgs.cmake
      ];
      configurePhase = "true";
      buildPhase = "cmake -Bbuild -H. -DPAHO_BUILD_STATIC=ON -DPAHO_BUILD_DOCUMENTATION=OFF -DCMAKE_INSTALL_PREFIX=$out";
      installPhase = "cmake --build build/ --target install";
    };
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      inherit pname;
      inherit version;
      src = self;

      buildInputs = [
        pkgs.openssl
        paho_mqtt_c
        paho_mqtt_cpp
      ];
      nativeBuildInputs = [
        pkgs.cmake
      ];

      configurePhase = "true";
      buildPhase = "cmake -Bbuild -H. -DCMAKE_INSTALL_PREFIX=$out";
      installPhase = "cmake --build build/ --target install";
    };
  };
}
