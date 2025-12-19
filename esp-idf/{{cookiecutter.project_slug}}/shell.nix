let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  nixpkgs-esp-dev = fetchTarball "https://github.com/mirrexagon/nixpkgs-esp-dev/archive/52a23afb15a1643a3dbeeb963097945a3f35b0fb.tar.gz";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ (import "${nixpkgs-esp-dev}/overlay.nix") ];
  };

  mk-qoi-conv =
    pythonPackage:
    pythonPackage.buildPythonPackage rec {
      pname = "qoi-conv";
      version = "1.0.2";
      src = pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-Fc97/jZOlHJOSkw8kD+i1pEMYAqNAAS08HZKdrRMKcE=";
      };
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
