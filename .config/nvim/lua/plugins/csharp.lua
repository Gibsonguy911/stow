return {
	"gibsonguy911/csharp.nvim",
	dependencies = {
		"Tastyep/structlog.nvim",
	},
	ft = { "cs" },
	opts = {
		testing = 1234,
		lsp = {
			omnisharp = {
				-- When set to false, csharp.nvim won't launch omnisharp automatically.
				enable = true,
				-- When set, csharp.nvim won't install omnisharp automatically. Instead, the omnisharp instance in the cmd_path will be used.
				cmd_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/omnisharp/omnisharp"),
				-- The default timeout when communicating with omnisharp
				default_timeout = 1000,
				-- Settings that'll be passed to the omnisharp server
				enable_editor_config_support = true,
				organize_imports = true,
				load_projects_on_demand = false,
				enable_analyzers_support = true,
				enable_import_completion = true,
				include_prerelease_sdks = true,
				analyze_open_documents_only = false,
				enable_package_auto_restore = true,
				-- Launches omnisharp in debug mode
				debug = false,
			},
			-- Sets if you want to use roslyn as your LSP
			roslyn = {
				-- When set to true, csharp.nvim will launch roslyn automatically.
				enable = false,
				-- Path to the roslyn LSP see 'Roslyn LSP Specific Prerequisites' above.
				cmd_path = nil,
			},
			-- The capabilities to pass to the omnisharp server
			capabilities = nil,
			-- on_attach function that'll be called when the LSP is attached to a buffer
			on_attach = nil,
		},
		logging = {
			-- The minimum log level.
			level = "INFO",
		},
		dap = {
			adapter_name = "coreclr",
		},
	},
}
