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
