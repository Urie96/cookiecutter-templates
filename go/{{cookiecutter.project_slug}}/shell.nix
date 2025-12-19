let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";

  goVersion = 22; # Change this to update the whole stack

  pkgs = import nixpkgs {
    config = { };
    overlays = [
      (final: prev: {
        go = final."go_1_${toString goVersion}";
      })
    ];
  };
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    go
    # gotools
    # golangci-lint
  ];
}
