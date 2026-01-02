return {
  'frostzt/bongo-cat.nvim',
  event = 'VeryLazy', -- Load lazily
  keys = {
    { '<leader>bc', '<cmd>BongoCat<cr>', desc = 'Toggle Bongo Cat' },
  },
  opts = {
    auto_start = true,
    window = {
      position = 'bottom-right',
    },
  },
}
