return {
  'potamides/pantran.nvim',
  config = function()
    local pantran = require 'pantran'
    pantran.setup {}

    local opts = { noremap = true, silent = true, expr = true }
    vim.keymap.set('n', '<Leader>tr', pantran.motion_translate, opts)
    vim.keymap.set('n', '<leader>trr', function()
      return pantran.motion_translate() .. '_'
    end, opts)
    vim.keymap.set('x', '<leader>tr', pantran.motion_translate, opts)
  end,
}
