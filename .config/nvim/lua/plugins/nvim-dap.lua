-- To tell Neovim if it should launch a debug adapter or connect to one, and if
-- so, how, you need to configure them via the `dap.adapters` table. The key of
-- the table is an arbitrary name that debug adapters are looked up by when using
-- a |dap-configuration|.
--
-- The dap-configuration does need to match the filetype you are configuring

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",  -- Optional: Provides a UI for nvim-dap
        "theHamsta/nvim-dap-virtual-text",  -- Optional: Shows virtual text for current frame variables
        "nvim-neotest/nvim-nio",
    },
    config = function()
        require("nvim-dap-virtual-text").setup()
        local dapui = require("dapui")
        dapui.setup()

        local dap = require("dap")

        -- Automatically open and close dap-ui
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end


        -- Basic Debugging Controls
        vim.keymap.set("n", "<F11>", dap.step_over)
        vim.keymap.set("n", "<F10>", dap.step_into)
        vim.keymap.set("n", "<F9>", dap.step_out)

        -- Breakpoints
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dB", function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end)
        vim.keymap.set("n", "<leader>dl", function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end)

        -- Debugging UI
        vim.keymap.set("n", "<leader>dr", dap.repl.open)

        vim.keymap.set({"n", "v"}, '<Leader>dh', function()
          require('dap.ui.widgets').hover()
        end)
        vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
            require('dap.ui.widgets').preview()
        end)
        vim.keymap.set('n', '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end)
        vim.keymap.set('n', '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end)

        -- Stopping and Restarting
        vim.keymap.set("n", "<leader>dq", dap.terminate)
        vim.keymap.set("n", "<leader>dr", dap.restart)
        vim.keymap.set("n", "<leader>dc", dap.continue)
        vim.keymap.set("n", "<leader>do", dapui.open)


        -- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#start-codelldb-automatically
        dap.adapters.codelldb = {
            type = "server",
            port = 13000,
            executable = {
                command = "/opt/codelldb_v1.11/codelldb",  
                args = { "--port", "13000", "--liblldb", "/opt/homebrew/opt/llvm/lib/liblldb.dylib" },
            },
        }

        dap.configurations.c = {
            {
                name = 'Remote: lldb-server platform --verbose --server --listen "*:4444" --gdbserver-port 4445',
                type = "codelldb",
                request = "launch",
                program = "/opt/code/build/bin/main", -- remote path
                args = {"-h"},
                initCommands = {
                    -- "log enable lldb default conn host comm",
                    "log enable lldb breakpoint command",
                    "platform select remote-linux",                    
                    "platform connect connect://127.0.0.1:4444",
                    "settings set target.inherit-env false",
                    "settings set target.source-map /opt/code ${workspaceFolder}"
                },
            },
        }

        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c

    end

}
