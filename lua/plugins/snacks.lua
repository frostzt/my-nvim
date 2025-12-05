return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = { input = {}, picker = {}, terminal = {}, lazygit = { enabled = true } },
  keys = {
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
  },
}
