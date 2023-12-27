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
        set mouse+=a
        set updatetime=100
        set clipboard=unnamedplus
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
]])
require("nvim-web-devicons").setup({})



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
require'lspconfig'.clangd.setup {}
require'lspconfig'.statix.setup {}
require'lspconfig'.marksman.setup {}
require'lspconfig'.tsserver.setup {}
require'lspconfig'.eslint.setup {}
require'lspconfig'.gopls.setup {}
require'lspconfig'.rust_analyzer.setup {}
require'lspconfig'.pylsp.setup {}
require'lspconfig'.ruff_lsp.setup {}
require'lspconfig'.terraformls.setup {}
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.omnisharp.setup{
    cmd = {"OmniSharp", "--languageserver"},
}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function() vim.lsp.buf.format() end
})

--CMP
local cmp = require('cmp')
cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'vsnip', keyword_length = 2}
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
        ["<>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm({select = false}),
        ["<C-l>"] = cmp.mapping.complete()
    }),
    snippet = {
        expand = function(args)
         vim.fn["vsnip#anonymous"](args.body)
        end
    }
})
vim.diagnostic.config({virtual_text = true})
vim.lsp.set_log_level("off")

--MAPING
vim.g.mapleader = " "
local wk = require("which-key")
wk.register({
    ["f"] = {"<cmd>Telescope find_files<CR>","find files"},
    ["b"] = {"<cmd>Telescope buffers<CR>","find buffers"},
    ["/"] = {"<cmd>Telescope live_grep<CR>","find text"},
    ["d"] = {"<cmd>Telescope diagnostics<CR>","find text"},
    --TODO toggle bkg ["t"] = {"<expr>&background == 'light' ? ':set bg=dark<cr>' : ':set bg=light<cr>'","toggle background"},
    --TODO toggle relative lines 
}, {prefix = "<leader>"})
require('Comment').setup()
--TODO auto pairs
--TODO select with in brackets
--Markdown images
--    -- MARKDOWN
--    {
--        'img-paste-devs/img-paste.vim',
--        config = function()
--            vim.cmd([[
--                autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
--            ]])
--        end
--    }, -- EDITOR UTILS
--    }, {"windwp/nvim-autopairs", event = "InsertEnter", opts = {}}, {
--require("lualine").setup({
-- options = {
--     icons_enabled = true,
--     theme = "auto",
--     component_separators = {left = "", right = ""},
--     section_separators = {left = "", right = ""},
--     disabled_filetypes = {statusline = {}, winbar = {}},
--     ignore_focus = {},
--     always_divide_middle = true,
--     globalstatus = false,
--     refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
-- },
-- sections = {
--     lualine_a = {"mode"},
--     lualine_b = {"branch", "diff", "diagnostics"},
--     lualine_c = {"filename"},
--     lualine_x = {"encoding", "fileformat", "filetype"},
--     lualine_y = {"progress"},
--     lualine_z = {"location"}
-- },
-- inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {"filename"},
--     lualine_x = {"location"},
--     lualine_y = {},
--     lualine_z = {}
-- },
-- tabline = {},
-- winbar = {},
-- inactive_winbar = {},
-- extensions = {}
--})
