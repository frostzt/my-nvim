return {
  'sudo-tee/opencode.nvim',
  config = function()
    require('opencode').setup {
      -- Disable all <leader>o keymaps to reduce AI dependence
      default_global_keymaps = false,
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- {
    --   'MeanderingProgrammer/render-markdown.nvim',
    --   opts = {
    --     anti_conceal = { enabled = false },
    --     file_types = { 'markdown', 'opencode_output' },
    --   },
    --   ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    -- },
  },
}
