let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
  };

  python = pkgs.python3;
in

pkgs.mkShellNoCC {
  venvDir = ".venv";
  packages = (
    with python.pkgs;
    [
      venvShellHook
      pip
    ]
  );

  postShellHook = ''
    venvVersionWarn() {
    	local venvVersion
    	venvVersion="$("$venvDir/bin/python" -c 'import platform; print(platform.python_version())')"

    	[[ "$venvVersion" == "${python.version}" ]] && return

    	cat <<EOF
    Warning: Python version mismatch: [$venvVersion (venv)] != [${python.version}]
             Delete '$venvDir' and reload to rebuild for version ${python.version}
    EOF
    }

    venvVersionWarn
  '';

}
