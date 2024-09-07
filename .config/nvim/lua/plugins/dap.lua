return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      vim.keymap.set('n', '<F4>', require('dap.ui.widgets').hover, { buffer = 0, desc = 'Show [F4] Hover' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Continue [F5] Debugging' })
      vim.keymap.set('n', '<F6>', dap.step_into, { desc = 'Step [F6] into' })
      vim.keymap.set('n', '<F7>', dap.step_over, { desc = 'Step [F7] over' })
      vim.keymap.set('n', '<F8>', dap.step_out, { desc = 'Step [F8] out' })
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Toggle [F9] breakpoint' })

      local csharp_adapter = {
        name = 'coreclr',
        desc = 'Managed C#',
        type = 'executable',
        command = vim.fn.expand '$HOME/.local/share/nvim/mason/packages/netcoredbg/netcoredbg',
        args = { '--interpreter=vscode' },
      }
      dap.adapters.coreclr = csharp_adapter

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch netcoredbg',
          request = 'launch',
          program = function()
            return vim.fn.input(

              'Path to dll: ',
              ---@diagnostic disable-next-line: redundant-parameter
              (function()
                local current_dir = vim.fn.expand '%:p:h'
                local bin_dir = nil

                while current_dir ~= '/' do
                  print(current_dir)
                  bin_dir = current_dir .. '/bin'
                  print('Checking for ' .. bin_dir)
                  if vim.fn.isdirectory(bin_dir) == 1 then
                    print(bin_dir .. ' exists')
                    local dir_name = vim.fn.fnamemodify(current_dir, ':t')
                    local dll_files = vim.fn.systemlist(string.format('rg --type-add dll:*.dll -u --files --type dll %s', bin_dir))
                    for _, dll_file in ipairs(dll_files) do
                      print('Dll file: ' .. dll_file)
                      local dll_name = vim.fn.fnamemodify(dll_file, ':t:r')
                      if dll_name == dir_name then
                        return dll_file
                      end
                    end
                    return 'bin folder exists but no matching dll found... try building the project first'
                  end

                  current_dir = vim.fn.fnamemodify(current_dir, ':h')
                end

                return 'no matching dll found'
              end)(),
              ---@diagnostic disable-next-line: redundant-parameter
              'file'
            )
          end,
        },
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()

      -- automatically open dapui when dap is called
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
