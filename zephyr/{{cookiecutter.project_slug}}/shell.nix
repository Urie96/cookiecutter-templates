let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
  };

  zephyr-src = sources.zephyr;

  pyproject-nix = import sources.pyproject-nix { lib = pkgs.lib; };

  zephyr-nix = pkgs.callPackage sources.zephyr-nix { inherit zephyr-src pyproject-nix; };

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
