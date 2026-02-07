{
  description = "nix-darwin system flake (Determinate Nix)";
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nix-darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      determinate,
      mac-app-util,
      ...
    }:
    {
      darwinConfigurations."mac-loganp" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          determinate.darwinModules.default
          { determinateNix.enable = true; }
          ./configuration.nix
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.loganphinney = import ./home.nix;
          }
        ];
        specialArgs = {
          inherit inputs self;
        };
      };
    };
}
