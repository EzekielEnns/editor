{
  description = "my editor config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        myConfig = pkgs.vimUtils.buildVimPlugin {
          name = "my-config";
          src = ./myNeovim;
          recursive = true;
        };
        myNeovim = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua require("init")
            '';
            packages.myPlugins = {
              start = [ myConfig ];
              opt = [ ];
            };
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            vimPlugins.nvim-treesitter-parsers.astro
            statix
            marksman
            terraform-ls
            nodePackages_latest.sql-formatter
            nodePackages_latest.typescript-language-server
            rust-analyzer
            gopls
            nodePackages_latest.vscode-langservers-extracted
            lua-language-server
            # formatters 
            nixfmt
            yamlfmt
            yamllint
            luaformatter
            nodePackages.prettier
            git
            myNeovim
          ];
        };
      });
}
