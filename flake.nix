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
    # Pinning a specific commit to fix a build issue for now
    #stylix.url = "github:danth/stylix/ed91a20c84a80a525780dcb5ea3387dddf6cd2de";
    # Great repository full of config tweaks for different hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Nix-based NeoVim distribution
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # An overlay for a Rust nix dev shell
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    rust-overlay,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      WyrmNix = nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit pkgs-stable;};

        modules = [
          ./nixos/configuration.nix
          # Loads the Stylix modules for both NixOS and home-manager
          inputs.stylix.nixosModules.stylix
          # Load up the Framework 16 specific configuration from nixos-hardware
          inputs.nixos-hardware.nixosModules.framework-16-7040-amd
          # Load the nixvim home-manager module
          #inputs.nixvim.homeManagerModules.nixvim

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.users.bwyrm = import ./home-manager/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit pkgs-stable;
              inherit inputs;
            };
          }
          # Overlay for the Rust nix dev shell
          ({pkgs, ...}: {
            nixpkgs.overlays = [rust-overlay.overlays.default];
            environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          })
        ];
      };
    };
  };
}
