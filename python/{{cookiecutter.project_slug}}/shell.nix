let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
  };

  customPython = pkgs.python3.withPackages (p: with p; [ pip ]);
in

pkgs.mkShellNoCC {
  venvDir = ".venv";
  packages =
    (with customPython.pkgs; [
      venvShellHook
    ])
    ++ (with pkgs; [
      customPython
      uv
    ]);
}
