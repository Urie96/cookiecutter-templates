let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
  # curl https://api.github.com/repos/nix-community/zephyr-nix/commits/master | grep -m 1 '"sha":' | cut -d '"' -f 4
  zephyr-nix-src = fetchTarball "https://github.com/nix-community/zephyr-nix/archive/c745709ea7362c7c3db6cfddabb875b68f4476de.tar.gz";

  # curl https://api.github.com/repos/pyproject-nix/pyproject.nix/commits/master | grep -m 1 '"sha":' | cut -d '"' -f 4
  pyproject-nix-src = fetchTarball "https://github.com/pyproject-nix/pyproject.nix/archive/e82d2bf1b96908f457ef199fa69e97825d9f228f.tar.gz";

  # curl -s https://api.github.com/repos/zephyrproject-rtos/zephyr/commits/v4.2.0 | grep -m 1 '"sha":' | cut -d '"' -f 4
  zephyr-src = fetchTarball "https://github.com/zephyrproject-rtos/zephyr/archive/413b789deb391d3a37d06b463288a5fe765ee57e.tar.gz";

  pyproject-nix = import pyproject-nix-src { lib = pkgs.lib; };

  zephyr-nix = pkgs.callPackage zephyr-nix-src { inherit zephyr-src pyproject-nix; };

  zephyr-sdk = zephyr-nix.sdks."0_17".sdk.override { targets = [ "arm-zephyr-eabi" ]; };
in
pkgs.mkShellNoCC {
  packages =
    (with pkgs; [
      cmake
      ninja
    ])
    ++ [
      zephyr-sdk
      zephyr-nix.pythonEnv
    ];
}
