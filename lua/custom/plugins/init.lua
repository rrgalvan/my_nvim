-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'benlubas/molten-nvim',
    ft = 'python',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      -- vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>")
      -- vim.keymap.set("v", "<localleader>mv", ":MoltenEvaluateVisual<CR>")
      -- vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>")
      -- vim.keymap.set("n", "<localleader>ml", ":MoltenEvaluateLine<CR>")
    end,
    keys = {
      { '<leader>mi', ':MoltenInit<cr>', desc = '[m]olten [i]nit' },
      { '<leader>mv', ':<C-u>MoltenEvaluateVisual<cr>', mode = 'v', desc = '[m]olten eval [v]isual' },
      { '<S-CR>', ':<C-u>MoltenEvaluateVisual<cr>', mode = 'v', desc = '[m]olten eval [v]isual' },
      { '<leader>mr', ':MoltenReevaluateCell<cr>', desc = '[m]olten [r]e-eval cell' },
      { '<leader>ml', ':MoltenEvaluateLine<cr>', desc = '[m]olten e-eval [l]ine' },
      { '<leader>mh', ':MoltenHideOutput<cr>', desc = '[m]olten [h]ide ouput' },
      { '<leader>ms', ':MoltenShowOutput<cr>', desc = '[m]olten [s]ide ouput' },
      { '<leader>md', ':MoltenDelete<cr>', desc = '[m]olten [d]delete' },
      { '<leader>mn', ':MoltenNext<cr>', desc = '[m]olten [n]ext cell' },
      { '<leader>mp', ':MoltenPrev<cr>', desc = '[m]olten [p]revious cell' },
      { '<C-n>', ':MoltenNext<cr>', desc = '[m]olten [n]ext cell' },
      { '<C-p>', ':MoltenPrev<cr>', desc = '[m]olten [p]revious cell' },
    },
  },
  {
    'benlubas/image-save.nvim',
    cmd = 'SaveImage',
    enable_mouse = true,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    dependencies = { 'peterbjorgensen/sved', lazy = false }, -- for evince
    -- dependencies = { "14mRh4X0r/evince.vim" }, -- for evince

    init = function()
      -- VimTeX configuration goes here, e.g.
      -- vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_method = 'evince'
      vim.g.vimtex_view_general_viewer = 'evince'
    end,
  },
  {
    'quarto-dev/quarto-nvim',
    ft = 'quarto',
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    init = function()
      local quarto = require 'quarto'
      quarto.setup()
      vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = false, noremap = true })
      require('quarto').setup {
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          chunks = 'curly',
          languages = { 'r', 'python', 'julia', 'bash', 'html' },
          diagnostics = {
            enabled = true,
            triggers = { 'BufWritePost' },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten', -- or 'slime'
          ft_runners = { python = 'molten' }, -- filetype to runner, ie. `{ python = "molten" }`.
          -- Takes precedence over `default_method`
          never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
        },
      }
    end,
  },
}
