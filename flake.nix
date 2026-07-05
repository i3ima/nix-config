{
  description = "Home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    username = "i3ima";
    system = "aarch64-linux";
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays/erlang.nix)
          (import ./overlays/freeswitch.nix)
        ];
      };
      modules = [ ./home.nix ];
    };
  };
}
