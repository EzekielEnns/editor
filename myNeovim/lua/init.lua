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
vim.g.mapleader = "<Space>"
require("nvim-web-devicons").setup({})
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
--        "neovim/nvim-lspconfig",
--        dependencies = {
--            "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
--            "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lsp",
--            "hrsh7th/cmp-nvim-lua", "L3MON4D3/LuaSnip",
--            "rafamadriz/friendly-snippets"
--        },
--        config = function()
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
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function() vim.lsp.buf.format() end
})

local cmp = require('cmp')
cmp.setup({
    sources = {
        {name = 'path'}, {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2}
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
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
            require('luasnip').lsp_expand(args.body)
        end
    }
})

vim.diagnostic.config({virtual_text = true})
vim.lsp.set_log_level("off")
-- vim.lsp.set_log_level("debug")
--        require("nvim-treesitter.configs").setup({
--            ensure_installed = {
--                "c", "lua", "rust", "terraform", "nu", "dockerfile", "diff",
--                "git_rebase", "gitignore", "gitcommit", "go", "gomod",
--                "json", "sql", "typescript", "tsx", "html", "css", "tsx",
--                "make", "astro"
--            },
--            highlight = {enable = true},
--            with_sync = true
--        })

local wk = require("which-key")
wk.register({
    ["f"] = {"<cmd>Telescope find_files<CR>","find files"},
    ["b"] = {"<cmd>Telescope buffers<CR>","find buffers"},
    ["/"] = {"<cmd>Telescope live_grep<CR>","find text"},
}, 
{
  mode = "n",
  prefix = "<space>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
  expr = false, -- use `expr` when creating keymaps
})

--  TODO
--
--    -- MARKDOWN
--    {
--        'img-paste-devs/img-paste.vim',
--        config = function()
--            vim.cmd([[
--                autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
--            ]])
--        end
--    }, -- EDITOR UTILS
--    {
--        "terrortylor/nvim-comment",
--        lazy = false,
--        keys = {{"<leader>/", ":'<,'>CommentToggle<CR>gv<esc>j", mode = {"v"}}},
--        config = function() require("nvim_comment").setup() end
--    }, {
--        "nvim-telescope/telescope.nvim",
--        tag = "0.1.1",
--        dependencies = {
--            "nvim-lua/plenary.nvim",
--            "nvim-telescope/telescope-live-grep-args.nvim"
--        },
--        config = function()
--            require("telescope").load_extension("live_grep_args")
--        end
--    }, {"windwp/nvim-autopairs", event = "InsertEnter", opts = {}}, {
--        "folke/which-key.nvim",
--        lazy = false,
--        config = function()
--            local which_key = require("which-key")
--            local setup = {
--                plugins = {
--                    marks = true, -- shows a list of your marks on ' and `
--                    presets = {
--                        windows = true, -- default bindings on <c-w>
--                        nav = true, -- misc bindings to work with windows
--                        z = true, -- bindings for folds, spelling and others prefixed with z
--                        g = true -- bindings for prefixed with g
--                    }
--                },
--                layout = {
--                    height = {min = 4, max = 25}, -- min and max height of the columns
--                    width = {min = 20, max = 50}, -- min and max width of the columns
--                    spacing = 3, -- spacing between columns
--                    align = "left" -- align columns left, center or right
--                },
--                ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
--                hidden = {
--                    "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:",
--                    "^ "
--                }, -- hide mapping boilerplate
--                show_help = true, -- show help message on the command line when the popup is visible
--                triggers = "auto", -- automatically setup triggers
--                triggers_blacklist = {i = {"j", "k"}, v = {"j", "k"}}
--            }
--
--            local opts = {
--                mode = "n", -- NORMAL mode
--                prefix = "<leader>",
--                buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--                silent = true, -- use `silent` when creating keymaps
--                noremap = true, -- use `noremap` when creating keymaps
--                nowait = true -- use `nowait` when creating keymaps
--            }
--
--            local mappings = {
--                ["k"] = {"<cmd>bdelete<CR>", "Kill Buffer"}, -- Close current file
--                ["p"] = {"<cmd>Lazy<CR>", "Plugin Manager"}, -- Invoking plugin manager
--                ["q"] = {"<cmd>qa<CR>", "Quit"}, -- Quit Neovim after saving the file
--                ["w"] = {"<cmd>w!<CR>", "Save"}, -- Save current file
--                ["r"] = {"<cmd>set relativenumber!<CR>", "Toggle relative"}, -- Save current file
--                ["a"] = {"<cmd>Alpha<CR>", "Menu"},
--                g = {
--                    name = "goto",
--                    d = {
--                        "<cmd>lua vim.lsp.buf.definition()<cr>",
--                        "jump to definition"
--                    },
--                    D = {
--                        "<cmd>lua vim.lsp.buf.declaration()<cr>",
--                        "jump to delcation"
--                    },
--                    i = {
--                        "<cmd>lua vim.lsp.buf.implementation()<cr>",
--                        "list all implementation"
--                    },
--                    o = {
--                        "<cmd>lua vim.lsp.buf.type_definition()<cr>",
--                        "jump to type def"
--                    },
--                    r = {"<cmd>lua vim.lsp.buf.references()<cr>", "references"},
--                    s = {
--                        "<cmd>lua vim.lsp.buf.signature_help()<cr>",
--                        "display signature info"
--                    },
--                    l = {
--                        "<cmd>lua vim.diagnostic.open_float()<cr>",
--                        "float diagnostic"
--                    }
--                },
--                e = {
--                    name = "Explorer",
--                    e = {
--                        "<cmd>Neotree  filesystem toggle float<CR>", "File exp"
--                    },
--                    b = {"<cmd>Neotree  buffers toggle float<CR>", "Buffer exp"},
--                    g = {"<cmd>Neotree  git_status toggle float<CR>", "Git exp"}
--                },
--                f = {
--                    name = "Finder",
--                    b = {"<cmd>Telescope buffers<CR>", "buffers"},
--                    w = {
--                        "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>",
--                        "Word in buffers"
--                    },
--                    p = {"<cmd>Telescope live_grep<CR>", "Word in project"},
--                    f = {"<cmd>Telescope find_files<CR>", "files"}
--                },
--                l = {
--                    -- https://neovim.io/doc/user/lsp.html
--                    name = "LSP",
--                    a = {"<cmd>lua vim.lsp.buf.code_action<cr>", "Code action"},
--                    i = {"<cmd>LSPInfo<cr>", "Info"},
--                    l = {
--                        "<cmd>lua vim.lsp.codelens.run()<cr>",
--                        "Codelens Actions"
--                    },
--                    r = {"<cmd>Telescope lsp_references<cr>", "Find reffernce"},
--                    s = {
--                        "<cmd>Telescope lsp_document_symbols<cr>",
--                        "Document Symbols"
--                    },
--                    S = {
--                        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--                        "Workspace Symbols"
--                    }
--                    -- TODO implement refactor options
--                }
--            }
--
--            which_key.setup(setup)
--            which_key.register(mappings, opts)
--        end
--    }
