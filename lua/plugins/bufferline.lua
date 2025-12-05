-- bufferline config
return {
  {
    'famiu/bufdelete.nvim',
  },
  {

    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    keys = {
      -- Buffer navigation
      { '<Tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous buffer' },
      { '<leader>bn', '<cmd>BufferLineCycleNext<cr>', desc = '[B]uffer [N]ext' },
      { '<leader>bp', '<cmd>BufferLineCyclePrev<cr>', desc = '[B]uffer [P]revious' },

      -- Move buffers
      { '<leader>bmn', '<cmd>BufferLineMoveNext<cr>', desc = '[B]uffer [M]ove [N]ext' },
      { '<leader>bmp', '<cmd>BufferLineMovePrev<cr>', desc = '[B]uffer [M]ove [P]revious' },

      -- Go to specific buffer (1-9)
      { '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to buffer 1' },
      { '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to buffer 2' },
      { '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to buffer 3' },
      { '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to buffer 4' },
      { '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to buffer 5' },
      { '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to buffer 6' },
      { '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to buffer 7' },
      { '<leader>8', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to buffer 8' },
      { '<leader>9', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to buffer 9' },
      { '<leader>$', '<cmd>BufferLineGoToBuffer -1<cr>', desc = 'Go to last buffer' },

      -- Close buffers
      { '<leader>bd', '<cmd>Bdelete!<cr>', { desc = '[B]uffer [D]elete', noremap = true, silent = true } },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = '[B]uffer [C]lose (pick)' },
      { '<leader>bh', '<cmd>BufferLineCloseLeft<cr>', desc = '[B]uffer close all to the left' },
      { '<leader>bl', '<cmd>BufferLineCloseRight<cr>', desc = '[B]uffer close all to the right' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = '[B]uffer close [O]thers' },

      -- Pick buffer
      { '<leader>bb', '<cmd>BufferLinePick<cr>', desc = '[B]uffer pick' },

      -- Pin/unpin buffer
      { '<leader>bP', '<cmd>BufferLineTogglePin<cr>', desc = '[B]uffer toggle [P]in' },

      -- Sort buffers
      { '<leader>bse', '<cmd>BufferLineSortByExtension<cr>', desc = '[B]uffer [S]ort by [E]xtension' },
      { '<leader>bsd', '<cmd>BufferLineSortByDirectory<cr>', desc = '[B]uffer [S]ort by [D]irectory' },
    },
    opts = {
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        themable = true,
        numbers = 'ordinal', -- "none" | "ordinal" | "buffer_id" | "both"
        close_command = function(bufnum)
          require('bufferline').close_buffer(bufnum)
        end,
        right_mouse_command = function(bufnum)
          require('bufferline').close_buffer(bufnum)
        end,
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        indicator = {
          icon = '▎',
          style = 'icon', -- 'icon' | 'underline' | 'none'
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 20,
        diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc"
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'center', -- "left" | "center" | "right"
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        sort_by = 'insert_after_current', -- 'insert_after_current' | 'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
      },
    },
  },
}
