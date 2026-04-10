-- Highlight, edit, and navigate code
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    -- The main branch manages only parser installation.
    -- Highlighting is handled natively by Neovim via vim.treesitter.
    -- No setup() call needed — plugin/ files handle auto-detection.
    config = function()
      require('nvim-treesitter.install').install {
        'go', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
        'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
}
