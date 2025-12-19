let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd487183437963a59ba763c0cc4f27e3447dd6dd.tar.gz";
  pkgs = import nixpkgs {
    config = { };
    overlays = [
      (
        final: prev:
        let
          javaVersion = 23;
          jdk = prev."jdk${toString javaVersion}";
        in
        {
          inherit jdk;
          maven = prev.maven.override { jdk_headless = jdk; };
          gradle = prev.gradle.override { java = jdk; };
          lombok = prev.lombok.override { inherit jdk; };
          jdt-language-server = prev.jdt-language-server.override { inherit jdk; };
        }
      )
    ];
  };
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    gcc
    jdk
    maven
    zlib
    jdt-language-server # lsp
  ];

  shellHook =
    let
      loadLombok = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
      prev = "\${JAVA_TOOL_OPTIONS:+ $JAVA_TOOL_OPTIONS}";
    in
    ''
      export JAVA_TOOL_OPTIONS="${loadLombok}${prev}"
    '';
}
