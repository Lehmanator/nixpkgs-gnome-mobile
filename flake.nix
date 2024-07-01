{
  description = "A Nix-flake to provide GNOME packages via overlay or nixosModule";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-gnome-apps.url = "github:chuangzhu/nixpkgs-gnome-apps";
    flakelight.url = "github:nix-community/flakelight";
  };
  outputs = { self, flakelight, ... }@inputs: flakelight ./. ({lib, ...}: {
    inherit inputs;
    systems = lib.systems.flakeExposed;
    nixDir = ./.;
    overlays.nixpkgs-gnome-apps = inputs.nixpkgs-gnome-apps.overlays.default;
    packages = rec {
      mutter = { gnome, fetchFromGitLab, ... }: gnome.mutter.overrideAttrs {
        version = "unstable-2023-09-05";
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "verdre";
          repo = "mobile-shell";
          rev = "0f08f5aba4c9b5ac34b2d5711182d50b719d838e";
          hash = "sha256-du56QMOlM7grN60eafoGTw2JGND6PK1gLrfWufihPO4=";
        };
      };
      mutter-devel = { gnome, fetchFromGitLab, ... }: gnome.mutter.overrideAttrs {
        version = "unstable-2024-05-06";
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "verdre";
          repo = "mobile-shell";
          rev = "9481723b9c1526ae89b4628573acbd06417bba2f";
          hash = "sha256-MRdsCRDR/x0KBo1F9bHc8TE085J1nAmFZ8xh4ZVDqNE=";
        };
      };
      gnome-shell = { gnome, fetchFromGitLab, ... }: (gnome.gnome-shell.overrideAttrs {
        version = "2024-04-29";
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "verdre";
          repo = "mobile-shell";
          rev = "b157a30ad43865e41e6cf5a632390d630b5a40df";
          hash = "sha256-DGz9TGgKs40Vx6FKZ5lsaAUtjEn61ZzRpF3UEP68PKM=";
          fetchSubmodules = true;
        };
      }).override { inherit mutter; };
      gnome-shell-devel = { gnome, fetchFromGitLab, ... }: (gnome.gnome-shell.overrideAttrs {
        version = "2024-04-29";
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "verdre";
          repo = "mobile-shell";
          rev = "ab6658f592937d46a8d428c39c3d2a98cf9063ea";
          hash = "sha256-dMTBY87e6g1QsYFi6PnCXD6NLDdg0/3iJ1Bk7ObIY4U=";
          fetchSubmodules = true;
        };
      }).override { inherit mutter; };
    };

    outputs = {
      inherit inputs;
      inherit lib;
      inherit (inputs.nixpkgs-gnome-apps) packages;
    };
  });

  nixConfig = {
    connect-timeout = 10;
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
      "https://lehmanator.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lehmanator.cachix.org-1:kT+TO3tnSoz+lxk2YZSsMOtVRZ7Gc57jaKWL57ox1wU="
    ];
  };
}
