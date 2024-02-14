{
  description = "A Nix-flake to provide GNOME packages via overlay or nixosModule";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-gnome-apps.url = "github:chuangzhu/nixpkgs-gnome-apps";
    #flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = ["aarch64-linux" "x86_64-linux"];
      perSystem = {
        config,
        lib,
        pkgs,
        system,
        inputs',
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [(import ./overlays/mobile.nix)];
        };
        #    (self: super: {
        #      gnome = super.gnome.overrideScope' (gself: gsuper: {
        #gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
        #  version = "45.2-mobile";
        #  src = super.fetchFromGitLab {
        #    domain = "gitlab.gnome.org";
        #    owner = "verdre";
        #    repo = "mobile-shell";
        #    rev = "df3f6b4c512d2f181e86ff7f6b1646ce7b907344";
        #    hash = "sha256-s47z1q+MZWogT99OkzgQxKrqFT4I0yXyfGSww1IaaFs=";
        #    fetchSubmodules = true;
        #  };
        #  # JS ERROR: Error: Requiring ModemManager, version none: Typelib file for namespace 'ModemManager' (any version) not found
        #  # @resource:///org/gnome/shell/misc/modemManager.js:4:49
        #  buildInputs = old.buildInputs ++ [super.modemmanager];
        #  postPatch = ''
        #    patchShebangs src/data-to-c.pl
        #    rm -f man/gnome-shell.1
        #  '';
        #});
        # --- develop ---
        #gnome-shell = gself.gnome-shell.overrideAttrs (old: {
        #  #version = "45.2-mobile-devel";
        #  version = "mobile-devel";
        #  src = super.fetchFromGitLab {
        #    domain = "gitlab.gnome.org";
        #    owner = "verdre";
        #    repo = "mobile-shell";
        #    rev = "259e12cfbe7060cdf63e106d275c0ee0d0158906";
        #    hash = "sha256-h3Qk1VhQDuXU9Y46hOMgO6OlYpdNIylIhLCroE5YTak=";
        #    fetchSubmodules = true;
        #  };
        #  postPatch = ''
        #    patchShebangs src/data-to-c.pl
        #    rm -f man/gnome-shell.1
        #  '';
        #});

        #mutter = gsuper.mutter.overrideAttrs (old: {
        #  version = "45.2-mobile";
        #  src = super.fetchFromGitLab {
        #    domain = "gitlab.gnome.org";
        #    owner = "verdre";
        #    repo = "mobile-mutter";
        #    rev = "0f08f5aba4c9b5ac34b2d5711182d50b719d838e";
        #    hash = "sha256-du56QMOlM7grN60eafoGTw2JGND6PK1gLrfWufihPO4=";
        #  };
        #});
        # --- develop ---
        #mutter = gself.mutter.overrideAttrs (old: {
        #  version = "mobile-devel";
        #  src = super.fetchFromGitLab {
        #    domain = "gitlab.gnome.org";
        #    owner = "verdre";
        #    repo = "mobile-mutter";
        #    rev = "742ac7a4fe1cacb1ff1ee21f132947c19b9498b7";
        #    hash =
        #      lib.fakeHash; # "sha256-D9TWF09XhqfBZyKXiPaQE+Fa+3mKG2CAdyi8nAsYa+c=";
        #  };
        #});
        #      });
        #    })
        #  ];
        #};
        devshells.updater = {
          devshell = {
            name = "updater";
            startup = {git-info.text = "${lib.getExe pkgs.onefetch}";};
          };
          packages = [
            pkgs.cachix
            pkgs.onefetch
            pkgs.nix-update
            pkgs.nix-universal-prefetch
          ];
          commands = [
            {
              name = "flake-update";
              help = "Update flake inputs";
              command = "nix flake update --commit-lock-file";
            }
            {
              name = "cachix-watcher";
              help = "Watch Nix store & push new paths to Cachix";
              command = "cachix watch";
            }
          ];
          serviceGroups.cachix = {
            name = "cachix";
            services.cachix-watch = {
              name = "cachix-watch";
              command = "${lib.getExe pkgs.cachix} watch";
            };
          };
        };
        formatter = pkgs.nixpkgs-fmt;
        packages = {
          inherit
            (inputs'.nixpkgs-gnome-apps.packages)
            avvie
            bunker
            flashcards
            gadgetcontroller
            iplan
            passes
            phosh-osk-stub
            pipeline
            purism-stream
            telegrand
            ;
          pmbootstrap = pkgs.callPackage ./pkgs/pmbootstrap.nix {};
          gnome-shell = pkgs.gnome.gnome-shell;
          gnome-shell-mobile = pkgs.gnome.gnome-shell;
          #gnome-shell-mobile-devel = pkgs.gnome.gnome-shell-devel;
          mutter = pkgs.gnome.mutter;
          mutter-mobile = pkgs.gnome.mutter;
          #mutter-mobile-devel = pkgs.gnome.mutter-devel;
          #mutter-mobile-devel = pkgs.callPackage ./pkgs/mutter-devel.nix {}; # gnome.mutter-devel;
          #gnome-shell-mobile = pkgs.callPackage ./pkgs/gnome-shell.nix {};
          #gnome-shell-mobile-devel =
          #  pkgs.callPackage ./pkgs/gnome-shell-devel.nix {};
          #mutter-mobile = pkgs.callPackage ./pkgs/mutter.nix {};
          #mutter-mobile-devel = pkgs.callPackage ./pkgs/mutter-devel.nix {};
        };
        #overlayAttrs = {
        #  inherit
        #    (config.packages)
        #    gnome-shell-mobile
        #    gnome-shell-mobile-devel
        #    mutter-mobile
        #    mutter-mobile-devel
        #    ;
        #};
        #apps.default = pkgs.nix-update;
      };
      flake = {
        overlays = rec {
          gnome-apps = inputs.nixpkgs-gnome-apps.overlays.default;
          gnome-mobile = import ./overlays/mobile.nix;
          gnome-mobile-devel = import ./overlays/devel.nix;
          default = gnome-mobile;
        };
        nixosModules = rec {
          gnome-mobile = import ./module.nix;
          default = gnome-mobile;
        };
      };
    };
  # https://zimbatm.com/notes/1000-instances-of-nixpkgs
  # https://discourse.nixos.org/t/1000-instances-of-nixpkgs/17347
  #let #pkgs = import nixpkgs.legacyPackages.${system};
  #  pkgs = import nixpkgs { inherit system; overlays = [ (import self.overlays.default) ]; };
  #in
  #rec # { inherit system; }; in rec
  #{
  #  packages = rec {
  #    gnome-shell-mobile = pkgs.gnome-shell;
  #    mutter-mobile = pkgs.mutter;
  #    default = gnome-shell-mobile;
  #  };
  #}) //

  nixConfig = {
    extra-substituters = ["https://lehmanator.cachix.org/"];
    extra-trusted-public-keys = [
      "lehmanator.cachix.org-1:kT+TO3tnSoz+lxk2YZSsMOtVRZ7Gc57jaKWL57ox1wU="
    ];
  };
}
