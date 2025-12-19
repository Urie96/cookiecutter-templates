let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  pkgs = import nixpkgs {
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
