{
  description = "MQTT client with C++ and CMake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
  };

  outputs = { self, nixpkgs }:
  let
    pname = "cpp-mqtt";
    version = "0.1.0";

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShell.${system} = with pkgs; mkShell {
      nativeBuildInputs = [
        gcc
        cmake
      ];
    };
  };
}
