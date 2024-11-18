-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'm4xshen/autoclose.nvim', -- Auto pair and close parenthesis
    config = function()
      require('autoclose').setup()
    end,
  },
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
    keys = {
      { '<leader>qp', ':QuartoPreview<cr>', desc = '[q]quarto [p]preview' },
    },
  },
  { -- send code from python/r/qmd documets to a terminal or REPL
    -- like ipython, R, bash
    'jpalardy/vim-slime',
    dev = false,
    init = function()
      vim.b['quarto_is_python_chunk'] = false
      Quarto_is_in_python_chunk = function()
        require('otter.tools.functions').is_otter_language_context 'python'
      end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]]

      vim.g.slime_target = 'neovim'
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true

      local function mark_terminal()
        local job_id = vim.b.terminal_job_id
        vim.print('job_id: ' .. job_id)
      end

      local function set_terminal()
        vim.fn.call('slime#config', {})
      end
      vim.keymap.set('n', '<leader>cm', mark_terminal, { desc = '[m]ark terminal' })
      vim.keymap.set('n', '<leader>cs', set_terminal, { desc = '[s]et terminal' })
    end,
  },
}
