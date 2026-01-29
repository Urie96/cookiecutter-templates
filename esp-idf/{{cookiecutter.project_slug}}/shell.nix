let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config.permittedInsecurePackages = [ "python3.13-ecdsa-0.19.1" ];
    overlays = [ (import "${sources.nixpkgs-esp-dev}/overlay.nix") ];
  };

  mk-qoi-conv =
    pythonPackage:
    let
      src = sources.qoi-conv;
    in
    pythonPackage.buildPythonPackage {
      pname = src.name;
      version = src.version;
      src = src;
      pyproject = true;
      build-system = [ pythonPackage.setuptools ];
      dependencies = with pythonPackage; [
        numpy
        pillow
      ];
    };

  esp-idf-full = pkgs.esp-idf-full.override {
    extraPythonPackages =
      p: with p; [
        patch
        pillow
        (mk-qoi-conv p)
      ];
  };
in

pkgs.mkShellNoCC {
  buildInputs = [
    esp-idf-full # esp32
    # esp8266-rtos-sdk # esp8266
  ];
}
