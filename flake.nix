{
  description = "my editor config flake";
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  };
  outputs = { self, nixpkgs, flake-utils, nixpkgs-unstable, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };
        upkgs = import nixpkgs-unstable {inherit system;};
        myConfig = pkgs.vimUtils.buildVimPlugin {
          name = "my-config";
          src = ./myNeovim;
          recursive = true;
        };
# TODO https://github.com/chrisgrieser/nvim-scissors
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
                    xml
                   ]
                ))
                nvim-lspconfig 
                trouble-nvim
                telescope-nvim
                
                nvim-cmp
                cmp-spell
                cmp-nvim-lsp
                cmp-buffer
                cmp-cmdline 
                cmp-path

                luasnip
                cmp_luasnip

                formatter-nvim 
                nvim-web-devicons 
                papercolor-theme
                vim-gitgutter
                which-key-nvim
                nvim-autopairs

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
            #geckodriver

            python311Packages.ruff-lsp
    	    dotnet-sdk_8 #TODO try and update version via unstable
            upkgs.csharp-ls
            #use csharp-ls for dotnet 8
            lemminx

            nil
            nodejs_latest
            nodePackages_latest.typescript-language-server
            #weird deps
            cargo
            rust-analyzer
            lua-language-server
            nodePackages_latest.pnpm


            # lang servers 
            ltex-ls
            texlab
            marksman
            nodePackages_latest.typescript-language-server
            tailwindcss-language-server
            gopls
            terraform-ls
            libclang
            vscode-langservers-extracted
            
            #need
            git
            myNeovim
          ];
        };
      });
}
