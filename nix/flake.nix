{
  description = "Francesco's dotfiles as a home-manager module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      # Supported systems
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # The main home-manager module
      homeManagerModules.default = import ./home.nix;

      # Alternative name for convenience
      homeManagerModules.dotfiles = self.homeManagerModules.default;

      # Example home-manager configuration for testing
      homeConfigurations = forAllSystems (system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            self.homeManagerModules.default
            {
              home.username = "example";
              home.homeDirectory = if nixpkgs.lib.hasPrefix "darwin" system
                then "/Users/example"
                else "/home/example";
              home.stateVersion = "24.05";

              # Enable all dotfiles
              programs.dotfiles.enable = true;
            }
          ];
        }
      );

      # Formatter for `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
