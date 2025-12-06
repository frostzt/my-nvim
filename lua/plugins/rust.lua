-- Enhanced Rust development
return {
  -- Rustaceanvim - Enhanced Rust support
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Custom keymaps for Rust
          vim.keymap.set('n', '<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = 'Rust: Code action', buffer = bufnr })

          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = 'Rust: Debuggables', buffer = bufnr })

          vim.keymap.set('n', '<leader>rr', function()
            vim.cmd.RustLsp 'runnables'
          end, { desc = 'Rust: Runnables', buffer = bufnr })

          vim.keymap.set('n', '<leader>rt', function()
            vim.cmd.RustLsp 'testables'
          end, { desc = 'Rust: Testables', buffer = bufnr })

          vim.keymap.set('n', '<leader>re', function()
            vim.cmd.RustLsp 'expandMacro'
          end, { desc = 'Rust: Expand macro', buffer = bufnr })

          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { desc = 'Rust: Hover actions', buffer = bufnr })
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              enable = true,
              command = 'clippy',
              extraArgs = { '--all', '--', '-W', 'clippy::all' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            inlayHints = {
              enable = true,
              showParameterNames = true,
              parameterHintsPrefix = '<- ',
              otherHintsPrefix = '=> ',
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('force', {}, opts or {})
    end,
  },

  -- Crates.nvim - Cargo.toml dependencies management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {},
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    config = function(_, opts)
      local crates = require 'crates'
      crates.setup(opts)

      -- Keymaps for Cargo.toml
      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('CmpSourceCargo', { clear = true }),
        pattern = 'Cargo.toml',
        callback = function()
          vim.keymap.set('n', '<leader>ct', crates.toggle, { desc = 'Crates: Toggle', buffer = true })
          vim.keymap.set('n', '<leader>cr', crates.reload, { desc = 'Crates: Reload', buffer = true })
          vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = 'Crates: Show versions', buffer = true })
          vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = 'Crates: Show features', buffer = true })
          vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, { desc = 'Crates: Show dependencies', buffer = true })
          vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = 'Crates: Update crate', buffer = true })
          vim.keymap.set('v', '<leader>cu', crates.update_crates, { desc = 'Crates: Update crates', buffer = true })
          vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = 'Crates: Update all', buffer = true })
          vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, { desc = 'Crates: Upgrade crate', buffer = true })
          vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, { desc = 'Crates: Upgrade crates', buffer = true })
          vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, { desc = 'Crates: Upgrade all', buffer = true })
        end,
      })
    end,
  },
}
