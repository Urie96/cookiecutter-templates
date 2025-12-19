let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  pkgs = import nixpkgs {
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
