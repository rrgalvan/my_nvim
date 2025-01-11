return {
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  dependencies = { 'peterbjorgensen/sved', lazy = false }, -- for evince
  -- dependencies = { "14mRh4X0r/evince.vim" }, -- for evince

  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'zathura'
    -- vim.g.vimtex_view_method = 'evince'
    -- vim.g.vimtex_view_general_viewer = 'evince'
  end,
}
