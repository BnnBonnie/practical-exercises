{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules = {
      url = "github:numtide/nixos-facter-modules";
    };
  };
  outputs = (
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      tools = import ./tools {lib = nixpkgs.lib;};
    in
    {
      nixosModules = tools.setFromDir ./modules;
      nixosConfigurations = builtins.listToAttrs (
        map ( machine: {
          name = machine;
          value = nixpkgs.lib.nixosSystem (
            let
              data = import ./machines/${machine};
            in {
              specialArgs = {
                inherit
                  inputs
                  data
                  tools
                ;
                flake-self = self;
              };
              system = data.system;
              modules = [
                ./machines/${machine}/configuration.nix
                inputs.disko.nixosModules.disko
                inputs.nixos-facter-modules.nixosModules.facter
                { config.facter.reportPath = ./facter.json; }
                ./machines/${machine}/disk.nix
                { imports = builtins.attrValues self.nixosModules; }
              ];
            }
          );
        }) (builtins.attrNames (
          nixpkgs.lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./machines)
        ))
      );
    }
  );
}
