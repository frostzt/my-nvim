-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- Don't ask about files outside cwd (important for multi-workspace)
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
    filesystem = {
      -- Don't change cwd when navigating
      bind_to_cwd = false,
      -- Follow current file without changing root
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true, -- Keep directories expanded
      },
      -- Don't prompt about files outside cwd
      cwd_target = {
        sidebar = 'none',
        current = 'none',
      },
      filtered_items = {
        visible = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
