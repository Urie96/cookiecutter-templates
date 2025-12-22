let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShell {
  packages =
    with pkgs;
    [
      clang-tools
      cmake
      codespell
      conan
      cppcheck
      doxygen
      gtest
      lcov
      platformio
      vcpkg
      vcpkg-tool
    ]
    ++ pkgs.lib.optionals (system != "aarch64-darwin") [ gdb ]
    ++ (with pkgs.python3Packages; [
      pip
    ]);

  shellHook = ''
    export PLATFORMIO_CORE_DIR=$PWD/.platformio
  '';
}
