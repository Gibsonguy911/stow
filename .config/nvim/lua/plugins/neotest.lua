return {
  {
    'nvim-neotest/neotest',
    dependencies = { 'nvim-neotest/neotest-plenary', 'Issafalcon/neotest-dotnet', 'nvim-neotest/nvim-nio' },
    ft = { 'cs' },
    keys = {
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        mode = 'n',
        desc = '[T]est [F]ile',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        mode = 'n',
        desc = '[T]est [N]earest',
      },
      {
        '<leader>ts',
        function()
          require('neotest').run.stop()
        end,
        mode = 'n',
        desc = '[T]est [S]top',
      },
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        mode = 'n',
        desc = '[T]est [A]ttach',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        mode = 'n',
        desc = '[T]est [D]ebug',
      },
      {
        '<leader>tp',
        function()
          require('neotest').run.run(vim.fn.getcwd())
        end,
        mode = 'n',
        desc = '[T]est [P]roject',
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-dotnet',
          require 'neotest-plenary',
          require 'neotest-dotnet' {
            dap = {
              args = { justMyCode = false },
              adapter_name = 'coreclr',
            },
            dotnet_additional_args = {
              '--verbosity detailed',
              '/p:CollectCoverage=true',
              '/p:CoverletOutputFormat=lcov',
              '/p:CoverletOutput=' .. vim.fn.getcwd() .. '/tests/coverage/lcov.info',
              '/p:Exclude=[*]*Migrations.*',
              '/p:ExcludeByFile="**/Microsoft.NET.Test.Sdk.Program.cs"',
            },
            discovery_root = 'solution',
          },
        },
      }
    end,
  },
  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim', 'Issafalcon/neotest-dotnet' },
    config = function()
      require('coverage').setup {
        lcov_file = vim.fn.getcwd() .. '/tests/coverage/lcov.info',
      }

      vim.keymap.set('n', '<leader>ccs', require('coverage').summary, { desc = '[C]ode [C]overage [S]ummary' })
      vim.keymap.set('n', '<leader>ccl', function()
        require('coverage').load_lcov(nil, true)
      end, { desc = '[C]ode [C]overage [L]oad' })
      vim.keymap.set('n', '<leader>cct', require('coverage').toggle, { desc = '[C]ode [C]overage [T]oggle' })
    end,
  },
}
