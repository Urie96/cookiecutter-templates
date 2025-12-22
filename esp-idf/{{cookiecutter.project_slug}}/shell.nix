let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config = { };
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

pkgs.mkShell {
  buildInputs = [
    esp-idf-full # esp32
    # esp8266-rtos-sdk # esp8266
  ];
}
