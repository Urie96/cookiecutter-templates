let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  packages =
    with pkgs;
    [
      clang-tools
      cmake
      conan
      cppcheck
      doxygen
      gtest
      lcov
      vcpkg
      vcpkg-tool
    ]
    ++ (if pkgs.stdenv.system == "aarch64-darwin" then [ ] else [ gdb ]);
}
