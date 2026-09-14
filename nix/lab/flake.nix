{
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      determinate,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.nix-lab = nixpkgs.lib.nixosSystem {
        modules = [
          determinate.nixosModules.default
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bak";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.loganp = import ./home.nix;
          }
        ];
      };
    };
}
