-- workspaces.nvim - Multi-root workspace management
-- Local development setup
return {
  dir = '~/Github/workspaces.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('workspaces').setup({
      -- Enable notifications
      notify = true,

      -- Sort by most recently used
      sort_by = 'recent',

      -- Don't change Neovim's cwd when switching workspaces
      -- Neo-tree handles its own root independently
      change_dir_on_switch = false,

      -- Auto-detect project roots
      auto_detect_root = true,

      -- Project root patterns
      root_patterns = {
        '.git',
        'package.json',
        'Cargo.toml',
        'go.mod',
        'pyproject.toml',
        'Makefile',
        '.project',
      },

      -- Integrations (all enabled by default)
      integrations = {
        neo_tree = { enabled = true },
        telescope = { enabled = true },
        fzf_lua = { enabled = true },
        lualine = { enabled = true, show_icon = true },
        lsp = { enabled = true, auto_add_workspace_folders = true },
      },
    })

    -- Setup keymaps
    local map = vim.keymap.set

    -- Workspace management
    map('n', '<leader>wa', ':WorkspaceAdd<CR>', { desc = '[W]orkspace [A]dd' })
    map('n', '<leader>wo', ':WorkspaceOpen<CR>', { desc = '[W]orkspace [O]pen' })
    map('n', '<leader>wc', ':WorkspaceClose<CR>', { desc = '[W]orkspace [C]lose' })
    map('n', '<leader>wl', ':WorkspaceList<CR>', { desc = '[W]orkspace [L]ist' })
    map('n', '<leader>ws', ':WorkspaceSelect<CR>', { desc = '[W]orkspace [S]elect' })
    map('n', '<leader>wp', ':WorkspacePicker<CR>', { desc = '[W]orkspace [P]icker' })
    map('n', '<leader>wP', ':WorkspacePicker all<CR>', { desc = '[W]orkspace [P]icker (all)' })

    -- Telescope workspace pickers
    map('n', '<leader>wf', function()
      require('workspaces.integrations.telescope').find_files()
    end, { desc = '[W]orkspace [F]iles' })

    map('n', '<leader>wg', function()
      require('workspaces.integrations.telescope').live_grep()
    end, { desc = '[W]orkspace [G]rep' })

    map('n', '<leader>wb', function()
      require('workspaces.integrations.telescope').buffers()
    end, { desc = '[W]orkspace [B]uffers' })

    map('n', '<leader>ww', function()
      require('workspaces.integrations.telescope').workspace_picker()
    end, { desc = '[W]orkspace picker (Telescope)' })

    -- Terminal
    map('n', '<leader>wt', ':WorkspaceTerminal<CR>', { desc = '[W]orkspace [T]erminal' })
    map('n', '<leader>wT', ':WorkspaceTerminal!<CR>', { desc = '[W]orkspace [T]erminal (float)' })

    -- Git
    map('n', '<leader>wG', ':WorkspaceGit lazygit<CR>', { desc = '[W]orkspace [G]it (lazygit)' })

    -- Neo-tree
    map('n', '<leader>we', ':WorkspaceTree<CR>', { desc = '[W]orkspace [E]xplorer' })
  end,
}
