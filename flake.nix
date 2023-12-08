{
  description = "my editor config flake";
  inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
            python311
            geckodriver

            python311Packages.ruff-lsp
            vimPlugins.nvim-treesitter-parsers.astro
            python311Packages.python-lsp-server
            statix
            nodePackages_latest.sql-formatter
            nodePackages_latest.typescript-language-server
            rust-analyzer
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

            # lang servers 
            marksman
            python311Packages.python-lsp-server
            nodePackages_latest.typescript-language-server
            gopls
            terraform-ls
            nil
#            OmniSharp
 #           clangd
            vscode-langservers-extracted
          ];
        };
      });
}
