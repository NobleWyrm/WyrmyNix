{
  description = "WyrmSec NixOS configuration";

  inputs = {
    # Cool people use unstable, it'll never fail me!
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Fallback for when unstable fails me.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Add home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # For fancy automated system-wide ricing
    stylix.url = "github:danth/stylix";

    # Great repository full of config tweaks for different hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Nix-based NeoVim distribution
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland added directly
    hyprland.url = "github:hyprwm/hyprland";

    # Fancy cursor theme I like
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
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

      Framewyrm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pkgs-stable;};

        modules = [
          ./nixos/core.nix
          ./hosts/Framewyrm/default.nix
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
        ];
      };

      Incus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pkgs-stable;};
        modules = [
          ./nixos/core.nix
          ./hosts/Menelon/default.nix
        ];
      };
    };
  };
}
