return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      {
        '<leader>o',
        function()
          require('oil').open()
        end,
        mode = 'n',
        desc = 'Toggle [O]il file explorer',
      },
    },
  },
}
