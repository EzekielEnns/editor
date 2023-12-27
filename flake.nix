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
              start = [ 
                pkgs.vimPlugins.telescope-nvim
                pkgs.vimPlugins.nvim-treesitter
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
                pkgs.vimPlugins.nvim-treesitter-textobjects
                pkgs.vimPlugins.nvim-lspconfig 
                pkgs.vimPlugins.trouble-nvim

                
                pkgs.vimPlugins.nvim-cmp
                pkgs.vimPlugins.cmp-nvim-lsp
                pkgs.vimPlugins.cmp-buffer
                pkgs.vimPlugins.cmp-cmdline 
                pkgs.vimPlugins.cmp-path
                pkgs.vimPlugins.formatter-nvim 
                pkgs.vimPlugins.cmp_luasnip
                pkgs.vimPlugins.vim-vsnip
                pkgs.vimPlugins.nvim-web-devicons 
                pkgs.vimPlugins.lualine-nvim
                pkgs.vimPlugins.papercolor-theme
                pkgs.vimPlugins.vim-gitgutter
                pkgs.vimPlugins.which-key-nvim

                pkgs.vimPlugins.comment-nvim
                myConfig 
              ];
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
            tailwindcss-language-server
            gopls
            terraform-ls
            nil
             helix
#            OmniSharp
 #           clangd
            vscode-langservers-extracted
          ];
        };
      });
}
