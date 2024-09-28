{
  description = "WyrmSec NixOS configuration";

  inputs = {
    # Cool people use unstable, it'll never fail me!
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Fallback for when unstable fails me.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # For fancy automated system-wide ricing
    stylix.url = "github:danth/stylix";
    # Great repository full of config tweaks for different hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  }: 
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      WyrmNix = nixpkgs.lib.nixosSystem rec {

        specialArgs = { inherit pkgs-stable; };

        modules = [
          ./nixos/configuration.nix
          # Loads the Stylix modules for both NixOS and home-manager
          inputs.stylix.nixosModules.stylix
          # Load up the Framework 16 specific configuration from nixos-hardware
          inputs.nixos-hardware.nixosModules.framework-16-7040-amd

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bwyrm = import ./home-manager/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
	    home-manager.extraSpecialArgs = { inherit pkgs-stable; };
          }
        ];
      };
    };
  };
}
