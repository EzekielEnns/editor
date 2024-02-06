vim.cmd([[
    "colors and cursor
        set encoding=UTF-8
        set background=dark
        set termguicolors
        set guicursor=
        set cmdheight=1

    "utils and special features
        set autoread
        set splitbelow
        set splitright
        "the mouse is evil.... on my laptop
        set mouse=
        set updatetime=100
        set encoding=utf-8
        set hidden
        set noerrorbells
        set noswapfile
        set nobackup
        set undodir=~/.vim/undodir
        set undofile
        set shortmess+=c

    "columns and numbers
        set nowrap
        set signcolumn=yes
        set number
        set relativenumber
        set ruler
        set scrolloff=13
        set colorcolumn=100

    "indenting
        set autoindent
        set smartindent
        set tabstop=4 softtabstop=4
        set shiftwidth=4
        set expandtab
        set confirm

    "searching
        set nohlsearch
        set incsearch

        set t_Co=256
        set background=dark
        colorscheme PaperColor
    
    "key bindings

        nnoremap  ga  <cmd>e#<CR>
        vnoremap  ga  <cmd>e#<CR>
]])
require("nvim-web-devicons").setup({})
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}



--LSP
require('trouble').setup({})
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local cap = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
require('cmp_nvim_lsp').default_capabilities())
lsp_defaults.capabilities = cap
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    end
})

require'lspconfig'.astro.setup {
    -- requires pnpm i -D @astrojs/language-server typescript
    cmd = {"pnpm", "astro-ls", "--stdio"}
}
require'lspconfig'.tailwindcss.setup {
    -- requires pnpm i -D @astrojs/language-server typescript
    cmd = {"pnpm", "tailwindcss-language-server", "--stdio"}
}
require'lspconfig'.ltex.setup{}
require'lspconfig'.texlab.setup{}
require'lspconfig'.clangd.setup {}
require'lspconfig'.nil_ls.setup{}
require'lspconfig'.marksman.setup {}
require'lspconfig'.tsserver.setup {}
require'lspconfig'.eslint.setup {}
require'lspconfig'.gopls.setup {}
require'lspconfig'.rust_analyzer.setup {}
require'lspconfig'.pylsp.setup {}
require'lspconfig'.ruff_lsp.setup {}
require'lspconfig'.terraformls.setup {}
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.lemminx.setup{}
require'lspconfig'.omnisharp.setup{
    --https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#omnisharp
    cmd = {'@@dotnet/dotnet','@@omnisharp/lib/omnisharp-roslyn/OmniSharp.dll'},
    enable_editorconfig_support = true,
    handlers = {
     ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function() vim.lsp.buf.format() end
})

--CMP
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'vsnip', keyword_length = 2},
        { name = 'luasnip' },
        {
            name = 'spell',
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
            },
         },
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫'
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end
    },

    mapping = cmp.mapping.preset.insert({
        ["<TAB>"] = cmp.mapping.select_next_item(),
        ["<S-TAB>"] = cmp.mapping.select_prev_item(),
        --["<>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm({select = false}),
        ["<C-l>"] = cmp.mapping.complete()
    }),
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
        end
    }
})
vim.diagnostic.config({virtual_text = true})
vim.lsp.set_log_level("off")
require("luasnip.loaders.from_vscode").lazy_load { paths = { "~/.config/snippets" } }
require("scissors").setup ({
    snippetDir = "~/.config/snippets",
})
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
-- When used in visual mode prefills the selection as body.
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)

--MAPING
vim.g.mapleader = " "
local wk = require("which-key")
local leader_binds = {
    ["f"] = {"<cmd>Telescope find_files<CR>","find files"},
    ["b"] = {"<cmd>Telescope buffers<CR>","find buffers"},
    ["/"] = {"<cmd>Telescope live_grep<CR>","find text"},
    ["d"] = {"<cmd>Telescope diagnostics<CR>","find text"},
    ["p"] = {'"+p',"find text from clip"},
    ["P"] = {'"+P',"paste from clip"},
    ["y"] = {'"+y',"yank from clip"},
    ["yy"] = {'"+yy',"yank line from clip"},
    ["Y"] = {'"+yg_',"yank line"},
    ["tr"] = {"<cmd>setlocal relativenumber!<CR>","toggle relative lines"},
    --TODO toggle relative lines 
}
wk.register(leader_binds, {prefix = "<leader>"})
wk.register(leader_binds, {prefix = "<leader>",mode = "v"})
require('Comment').setup()
--TODO add formatters
require("formatter").setup {}
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

