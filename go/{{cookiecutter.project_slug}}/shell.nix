let
  sources = import ./nix/sources.nix;

  goVersion = 25; # Change this to update the whole stack

  pkgs = import sources.nixpkgs {
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
