{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        zephyr.url = "github:zephyrproject-rtos/zephyr/v4.2.0";
        zephyr.flake = false;

        zephyr-nix.url = "github:nix-community/zephyr-nix/b614ffaa1343beacaca254213451186af10e88f6";
        zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";
        zephyr-nix.inputs.zephyr.follows = "zephyr";
    };

    outputs = { self, nixpkgs, zephyr-nix, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            /*config = {
                allowUnfree = true;
                segger-jlink.acceptLicense = true;
                permittedInsecurePackages = [
                    "segger-jlink-qt4-824"
                ];
            };*/
        };
        zephyr = zephyr-nix.packages.${system};
    in {
        devShells.${system}.default = pkgs.mkShell {
            packages = [
                (zephyr.sdk-0_17.override {
                    targets = [
                        "arm-zephyr-eabi"
                    ];
                })
                zephyr.pythonEnv
                zephyr.hosttools-nix
                pkgs.cmake
                pkgs.ninja
                /*pkgs.segger-jlink*/
                pkgs.dfu-util
            ];
        };
    };
}
