return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/neodev.nvim',
        config = function()
          require('neodev').setup {
            library = {
              plugins = {
                'neotest',
                'nvim-dap-ui',
              },
              types = true,
            },
          }
        end,
      },
    },
    config = function()
      -- This is a helper function that creates a keymap for a specific buffer
      local map = function(keys, func, buf, desc)
        vim.keymap.set('n', keys, func, { buffer = buf, desc = desc })
      end

      -- This is a helper function that creates a template for a specific buffer
      -- This is specific to C# files and will create a class or interface template
      local template_buffer = function(type)
        local current = vim.fn.expand '%:p'
        local dir = vim.fn.fnamemodify(current, ':h')
        local project_dir = vim.fn.getcwd()
        local csproj_dir = nil

        while dir ~= project_dir do
          local files = vim.fn.systemlist(string.format('rg --type-add csproj:*.csproj --files --type csproj --max-depth 1 %s', dir))
          if #files > 0 then
            csproj_dir = dir
            break
          end
          dir = vim.fn.fnamemodify(dir, ':h')
        end

        if csproj_dir == nil then
          print 'no .csproj found'
          return
        end

        local n = vim.fn.fnamemodify(csproj_dir, ':t') .. current:sub(#csproj_dir + 1)
        n = vim.fn.fnamemodify(n, ':h')
        n = n:gsub('[/\\]', '.')

        local className = vim.fn.fnamemodify(vim.fn.expand '%:t', ':r')
        local class = ''
        if type:find('interface', 1, true) then
          class = 'public ' .. type .. ' I' .. className
        else
          class = 'public ' .. type .. ' ' .. className
        end
        vim.api.nvim_buf_set_lines(0, 0, 1, false, { 'namespace ' .. n .. ';', '', class, '{', '', '}' })

        -- Move cursor to the class body
        vim.api.nvim_win_set_cursor(0, { 5, 0 })
        -- save current file
        vim.cmd 'w'
      end

      -- autocommands are a way to run code when certain events happen in Neovim
      -- In this case, we're running code when a new LSP client attaches to a buffer
      -- This is useful because we can set up keymaps and other things that are specific
      -- to the language server that is being attached to the buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.

          -- Adding custom keymaps and templates for C# files
          if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':e') == 'cs' then
            map('gd', require('csharp').go_to_definition, event.buf, '[CS]: [G]oto [D]efinition')

            map('<leader>cfu', require('csharp').fix_usings, event.buf, '[C]#: [F]ix [U]sings')

            -- template keymaps
            map('<leader>tc', function()
              template_buffer 'class'
            end, event.buf, '[T]emplate [C]lass')
            map('<leader>ti', function()
              template_buffer 'interface'
            end, event.buf, '[T]emplate [I]nterface')
            map('<leader>te', function()
              template_buffer 'enum'
            end, event.buf, '[T]emplate [E]num')
          else
            --  To jump back, press <C-t>.
            map('gd', require('telescope.builtin').lsp_definitions, event.buf, '[G]oto [D]efinition')
          end

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, event.buf, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, event.buf, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, event.buf, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, event.buf, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, event.buf, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, event.buf, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, event.buf, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('<leader>h', vim.lsp.buf.hover, event.buf, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, event.buf, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, event.buf, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        omnisharp = {},
        netcoredbg = {},
        csharpier = {},
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            if server_name == 'omnisharp' then
              return
            end
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
