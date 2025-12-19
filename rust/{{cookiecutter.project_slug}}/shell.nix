let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  rust-overlay = fetchTarball "https://github.com/oxalica/rust-overlay/archive/09442765a05c2ca617c20ed68d9613da92a2d96b.tar.gz";
  pkgs = import nixpkgs {
    config = { };
    overlays = [
      (import rust-overlay)
    ];
  };

  rust-tool-chain =
    let
      rust = pkgs.rust-bin;
    in
    if builtins.pathExists ./rust-toolchain.toml then
      rust.fromRustupToolchainFile ./rust-toolchain.toml
    else if builtins.pathExists ./rust-toolchain then
      rust.fromRustupToolchainFile ./rust-toolchain
    else
      rust.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rustfmt"
        ];
      };
in
pkgs.mkShell {
  packages = with pkgs; [
    rust-tool-chain

    openssl
    pkg-config
    cargo-deny
    cargo-edit
    cargo-watch
    rust-analyzer
  ];

  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH = "${rust-tool-chain}/lib/rustlib/src/rust/library";
  };
}
