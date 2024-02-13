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
          patchPhase = ''
            substituteInPlace lua/init.lua \
                --replace '@@omnisharp' '${pkgs.omnisharp-roslyn}' \
                --replace '@@dotnet' '${pkgs.dotnet-sdk_8}'
          '';
        };
        myNeovim = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua require("init")
            '';
            packages.myPlugins = with pkgs.vimPlugins; {
              start = [ 
                (pkgs.vimUtils.buildVimPlugin {
                    name = "annotate";
                    dependencies=[sqlite-lua];
                    src = pkgs.fetchFromGitHub {
                        repo = "annotate.nvim";
                        owner = "winter-again";
                        rev = "customize-db-location";
                        sha256 = "sha256-Y7WdxHsYAjQgt9dxmsJCmS4X/myJ5SweBUxyuS/QbyM=";
                    };
                 })
                (pkgs.vimUtils.buildVimPlugin {
                    name = "winresizer";
                    src = pkgs.fetchFromGitHub {
                        repo = "winresizer";
                        owner = "simeji";
                        rev = "master";
                        sha256 = "sha256-5LR9A23BvpCBY9QVSF9PadRuDSBjv+knHSmdQn/3mH0=";
                    };
                 })
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
                    kotlin
                   ]
                ))
                nvim-lspconfig 
                trouble-nvim
                telescope-nvim
                hardtime-nvim               
                nvim-cmp
                cmp-spell
                cmp-nvim-lsp
                cmp-buffer
                cmp-cmdline 
                cmp-path

                luasnip
                cmp_luasnip
                omnisharp-extended-lsp-nvim
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
            #dotnet
    	    dotnet-sdk_8 
            omnisharp-roslyn

            kotlin-language-server
            lemminx
            vscode-langservers-extracted
            quick-lint-js
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
