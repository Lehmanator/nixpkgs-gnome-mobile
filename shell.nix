{ pkgs, ... }:
#pkgs.mkShell {
#  packages ? [ bashInteractive common-updater-scripts coreutils git ],
#  inputsFrom ? [packages.myPackage]
#};

pkgs.mkShell {
  name = "Updater";
  # Executable packages in nix shell environment.
  packages = [ pkgs.bashInteractive pkgs.common-updater-scripts pkgs.coreutils pkgs.git ];
  nativeBuildInputs = [ ];
  buildInputs = [ ];
  # Build dependencies of the listed derivations to the nix shell environment.
  inputsFrom = [ ];
  NIX_DEBUG = 5;
  shellHook = ''
    develop=0
    function update-git-repo() {
      pkg="\$\{1:-shell}"
      branch="mobile-$pkg"
      devel="$2"
      if [ devel -e ] then branch+="-devel" fi
      tmpdir="$(mktemp -d)"
      git clone --bare --depth=1 --branch="$branch" \
        "https://gitlab.gnome.org/verdre/mobile-$pkg.git" "$tmpdir"
      pushd "$tmpdir"
      new_version="unstable-$(git show -s --pretty='format:%cs')"
      commit_sha="$(git show -s --pretty='format:%H')"
      popd
      update-source-version "gnome.gnome-$pkg" \
        --file=overlay.nix "$new_version" \
        --rev="$commit_sha"
    }
    update-git-repo "shell"  $devel
    update-git-repo "mutter" $devel
  '';
}
