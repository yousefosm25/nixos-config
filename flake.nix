{
  description = "yousef's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    lazyvim.url = "github:pfassina/lazyvim-nix";
    #nvf-config
    nvf.url = "github:notashelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    zen-browser,
    nvf,
    catppuccin,
    lazyvim,
    ...
  } @ inputs: {
#nvf-config
    packages."x86_64-linux".default =
      nvf.lib.neovimConfiguration {};


    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        catppuccin.nixosModules.catppuccin

        ./configuration.nix

        nvf.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit  zen-browser lazyvim;};
          home-manager.users.yousef = import ./home.nix;
        }
      ];
    };
  };
}
