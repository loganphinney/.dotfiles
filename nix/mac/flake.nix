{
  description = "nix-darwin system flake (Determinate Nix)";
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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
            home-manager.backupFileExtension = ".bak";
            home-manager.users.loganphinney = import ./home.nix;
          }
        ];
        specialArgs = {
          inherit inputs self;
        };
      };
    };
}
