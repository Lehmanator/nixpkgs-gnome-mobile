{
  description = "A Nix-flake to provide GNOME packages via overlay or nixosModule";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, ... }: {
    overlays.default = import ./overlay.nix;
    nixosModules.gnome-mobile = import ./module.nix;
  };
}
