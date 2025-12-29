let

  sources = import ./nix/sources.nix;
  arduino-nix = builtins.getFlake "${sources.arduino-nix}/${sources.arduino-nix.version}";
  arduino-index = import sources.arduino-index;

  pkgs = import sources.nixpkgs {
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
  packages = [
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
