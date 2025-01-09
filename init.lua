-- SETTINGS
local set = vim.opt

set.tabstop=4
set.softtabstop=4
set.shiftwidth=4

set.number=true
set.relativenumber=true

set.scrolloff=5

vim.cmd('colorscheme default')

-- PLUGINS
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'

vim.call('plug#end')

require('nvim-treesitter.configs').setup({
	ensure_installed = "all",
	highlight = {
		enable = true,
	},
})

-- LSP CLIENTS
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup({
	on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
		return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
		runtime = {
			-- Tell the language server which version of Lua you're using
			-- (most likely LuaJIT in the case of Neovim)
		version = 'LuaJIT'
		},
			-- Make the server aware of Neovim runtime files
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME
				-- Depending on the usage, you might want to add additional paths here.
				-- "${3rd}/luv/library"
				-- "${3rd}/busted/library",
			}
			-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
			-- library = vim.api.nvim_get_runtime_file("", true)
		}
	})
	end,
	settings = {
		Lua = {
			diagnostics = {
				enable = true,
				showSquiggles = true,
				hoverWithActions = true,
				showFunctionSignatureHelp = true,
				completionTriggers = {"."},
			},
		},
	},
})

lspconfig.gopls.setup({
	settings = {
        gopls = {
            analyses = {
                unusedparams = true, -- Enable unused parameters analysis
                nilness = true,       -- Enable nilness analysis
                unusedwrite = true,   -- Enable unused writes analysis
                useany = true,        -- Enable use of any type analysis
            },
            staticcheck = true,     -- Enable static analysis
            gofumpt = true,         -- Format Go files on save
            codelenses = {
                gc_details = false,  -- Disable generating details for gc
                generate = true,      -- Enable generating code
                regenerate_cgo = true, -- Enable regenerating cgo
                run_govulncheck = true, -- Enable running govulncheck
                test = true,          -- Enable running tests
                tidy = true,          -- Enable tidying imports
                upgrade_dependency = true, -- Enable upgrading dependencies
                vendor = true,        -- Enable vendoring
            },
            hints = {
                assignVariableTypes = true, -- Enable assigning types to variables
                compositeLiteralFields = true, -- Enable hints for composite literal fields
                compositeLiteralTypes = true, -- Enable hints for composite literal types
                constantValues = true, -- Enable hints for constant values
                functionTypeParameters = true, -- Enable hints for function type parameters
                parameterNames = true, -- Enable hints for parameter names
                rangeVariableTypes = true, -- Enable hints for range variable types
            },
            usePlaceholders = true, -- Use placeholders for untyped expressions
            completeUnimported = true, -- Complete unimported identifiers
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" }, -- Exclude directories from analysis
            semanticTokens = true, -- Enable semantic tokens
        },
    },
})

lspconfig.ccls.setup({
	init_options = {
		compilationDatabaseDirectory = "build";
		index = {
			threads = 0;
		};
		clang = {
			excludeArgs = { "-frounding-math"} ;
		};
	}
})

lspconfig.rust_analyzer.setup({
	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = false;
			}
		}
	}
})

lspconfig.html.setup({})

lspconfig.css_variables.setup({})

lspconfig.cssls.setup({})

lspconfig.cssmodules_ls.setup({})

