-- debug.lua
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Installers
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Debuggers
    'leoluz/nvim-dap-go',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<F4>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Stop/Terminate',
    },
    {
      '<F6>',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'codelldb',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- C++ debugging configuration
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Helper: split string into args table
    local function split_args(str)
      local args = {}
      for arg in (str or ''):gmatch('%S+') do
        table.insert(args, arg)
      end
      return args
    end

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
          return split_args(vim.fn.input('Arguments: ', ''))
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Launch (stop on entry)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
          return split_args(vim.fn.input('Arguments: ', ''))
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
      },
      {
        name = 'Attach to process',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
      },
    }

    dap.configurations.c = dap.configurations.cpp

    -- Load project-local debug config if it exists (.nvim-dap.lua)
    -- This file can define/override dap.configurations for this project
    local local_config = vim.fn.getcwd() .. '/.nvim-dap.lua'
    if vim.fn.filereadable(local_config) == 1 then
      dofile(local_config)
    end

    -- Memory view helper functions for C/C++ debugging
    local function read_memory()
      local session = dap.session()
      if not session then
        vim.notify('No active debug session', vim.log.levels.WARN)
        return
      end
      local addr = vim.fn.input 'Memory address (hex): 0x'
      if addr == '' then
        return
      end
      local count = vim.fn.input 'Bytes to read [64]: '
      count = count == '' and '64' or count
      -- Use LLDB command via repl
      dap.repl.execute('memory read -c ' .. count .. ' 0x' .. addr)
      dap.repl.open()
    end

    local function examine_memory()
      local session = dap.session()
      if not session then
        vim.notify('No active debug session', vim.log.levels.WARN)
        return
      end
      local expr = vim.fn.input 'Expression (variable/address): '
      if expr == '' then
        return
      end
      local format = vim.fn.input 'Format [x=hex, d=decimal, s=string, i=instruction]: '
      format = format == '' and 'x' or format
      local count = vim.fn.input 'Count [16]: '
      count = count == '' and '16' or count
      -- Use LLDB examine command
      dap.repl.execute('x/' .. count .. format .. ' ' .. expr)
      dap.repl.open()
    end

    -- Memory view keymaps (only active during debug sessions)
    vim.keymap.set('n', '<leader>dm', read_memory, { desc = 'Debug: Read [M]emory' })
    vim.keymap.set('n', '<leader>dx', examine_memory, { desc = 'Debug: E[x]amine memory' })
    vim.keymap.set('n', '<leader>dr', function()
      dap.repl.open()
    end, { desc = 'Debug: Open [R]EPL' })
  end,
}
