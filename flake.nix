{
  description = "Oasoas's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... } @ inputs:
  let
    inherit (self) outputs;
  in
  {
    nixpkgs.config.allowUnfree = true;
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/desktop/configuration.nix
        stylix.nixosModules.stylix
      ];
    };

    homeConfigurations.osama = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home/home.nix
      ];
    };
  };
}
