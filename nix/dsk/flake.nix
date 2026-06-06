{
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    lanzaboote = {
      url = "https://flakehub.com/f/nix-community/lanzaboote/1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
        modules = [
          determinate.nixosModules.default
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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
