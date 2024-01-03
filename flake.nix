{
  description = "my editor config flake";
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };
        myConfig = pkgs.vimUtils.buildVimPlugin {
          name = "my-config";
          src = ./myNeovim;
          recursive = true;
        };
        # TODO add markdown plugin
        # vim-theme-purify = pkgs.vimUtils.buildVimPlugin {
        #     name= "vim-purify";
        #     src = pkgs.fetchFromGitHub {
        #         repo = "purify";
        #         owner = "kyoz";
        #         rev = "70011ccc3225feb2e7bedda36d226adcf221f7ae/vim";
        #         sha256 = "sha256-QR8O9QtPxrvRKo8PcwSLG3f6z+59xCX3KC6C3VLOMBA=";
        #     };
        # };
        myNeovim = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua require("init")
            '';
            packages.myPlugins = with pkgs.vimPlugins; {
              start = [ 
                nvim-treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                # nvim-treesitter-parsers.astro
                # nvim-treesitter-parsers.go
                # nvim-treesitter-parsers.rust
                # nvim-treesitter-parsers.markdown
                (nvim-treesitter.withPlugins (
                   plugins: with plugins; [
                    wgsl
                    nix
                    tsx
                    toml
                    python
                    astro
                    rust
                    html
                    typescript
                    c
                    go
                    sql
                    markdown
                   ]
                ))

                nvim-lspconfig 
                trouble-nvim
                telescope-nvim

                
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                cmp-cmdline 
                cmp-path
                formatter-nvim 
                cmp_luasnip
                vim-vsnip
                nvim-web-devicons 
                lualine-nvim
                papercolor-theme
                vim-gitgutter
                which-key-nvim

                comment-nvim
                myConfig 
              ];
              opt = [ ];
            };
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            tree-sitter
            python311
            geckodriver

            python311Packages.ruff-lsp
            vimPlugins.nvim-treesitter-parsers.astro
            python311Packages.python-lsp-server
            statix
            nodejs_latest
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
            ltex-ls
            texlab
            marksman
            python311Packages.python-lsp-server
            nodePackages_latest.typescript-language-server
            tailwindcss-language-server
            gopls
            terraform-ls
            nil
            helix
            libclang
            vscode-langservers-extracted
            #for dot net dotnet-sdk_8
            dotnet-sdk_8
            msbuild
            powershell
            omnisharp-roslyn
            mono
          ];
        };
      });
}
