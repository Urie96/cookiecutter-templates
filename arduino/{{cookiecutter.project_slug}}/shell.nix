let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  arduino-nix = builtins.getFlake "github:bouk/arduino-nix/cfa82ced5b5d9436edec9238cf493f6b2c643869";
  arduino-index = fetchTarball "https://github.com/bouk/arduino-indexes/archive/8d5056dfa632df9fabcd1d9443a3b6984d63868e.tar.gz";

  pkgs = import nixpkgs {
    config = { };
    overlays = [
      (arduino-nix.overlay)
      (arduino-nix.mkArduinoLibraryOverlay (arduino-index + "/index/library_index.json"))
      (arduino-nix.mkArduinoPackageOverlay (arduino-index + "/index/package_index.json"))
      (arduino-nix.mkArduinoPackageOverlay (arduino-index + "/index/package_esp32_index.json"))
    ];
  };

  custom-arduino-cli = pkgs.wrapArduinoCLI {
    packages = with pkgs.arduinoPackages; [
      platforms.esp32.esp32."3.3.2"
    ];
  };
in

pkgs.mkShell {
  packages =
    [
      custom-arduino-cli
    ]
    ++ (with pkgs; [
      arduino-language-server
      clang
    ]);

  shellHook = ''
    arduino-cli config dump --json | ${pkgs.yq-go}/bin/yq -P >".arduino-cli.yaml"
    export ARDUINO_CLI_CONFIG=".arduino-cli.yaml"
  '';
}
