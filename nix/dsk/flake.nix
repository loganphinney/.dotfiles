{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    lanzaboote.url = "https://flakehub.com/f/nix-community/lanzaboote/1.1.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:epireyn/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.url = "github:noctalia-dev/noctalia/v5.1.0";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      determinate,
      lanzaboote,
      home-manager,
      niri,
      noctalia,
      ...
    }:
    {
      nixosConfigurations.nix-dsk = nixpkgs.lib.nixosSystem {
        modules = [
          determinate.nixosModules.default
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bak";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.loganp.imports = [
              ./home.nix
              niri.homeModules.niri
              noctalia.homeModules.default
            ];
          }
        ];
      };
    };
}
