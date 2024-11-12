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
        local dap = require("dap")
        dap.set_log_level("DEBUG")
        dap.defaults.timeout = 30000  -- Set timeout to 30 seconds


        -- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#start-codelldb-automatically
        dap.adapters.codelldb = {
            type = "server",
            port = 13000,
            executable = {
                command = "/opt/codelldb_v1.11/codelldb",  
                args = { "--port", "13000", "--liblldb", "/opt/homebrew/opt/llvm/lib/liblldb.dylib" },
            },
        }

        dap.adapters.lldb_dap = {
            type = "executable",
            command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
        }

        dap.configurations.c = {
            {
                name = 'Remote: lldb-server platform --verbose --server --listen "*:4444" --gdbserver-port 4445',
                type = "codelldb",
                request = "launch",
                program = "${workspaceFolder}/build/bin/main", -- local path
                args = {"-h"},
                initCommands = {
                    -- "log enable lldb default conn host comm",
                    "log enable lldb breakpoint command",
                    "platform select remote-linux",                    
                    "platform connect connect://127.0.0.1:4444",
                    "settings set target.inherit-env false",
                },
            },
            {
                name = 'lldb-dap: Remote: lldb-server platform --verbose --server --listen "*:4444" --gdbserver-port 4445',
                type = "lldb_dap",
                request = "attach",
                -- program = "${workspaceFolder}/build/bin/main", -- local path
                attachCommands = {
                    "log enable lldb default conn host comm",
                    "gdb-remote 127.0.0.1:4444"
                }
            }
        } -- end config
            -- program = function()
            --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            -- end,
            -- cwd = '${workspaceFolder}',


        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c

        -- Still inside the config function
        require("dapui").setup()

        -- Automatically open and close dap-ui
        dap.listeners.after.event_initialized["dapui_config"] = function()
          require("dapui").open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          require("dapui").close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          require("dapui").close()
        end
    end

}



---
-- ---            {
--                 name = "Launch remote program",
--                 type = "codelldb",
--                 program = "/opt/code/build/bin/main",
--                 request = "launch",
--                 cwd = "${workspaceFolder}",
--                 stopOnEntry = false,
--                 MIMode = "lldb",
--                 miDebuggerPath = "/opt/homebrew/llvm/bin/lldb",
--                 miDebuggerServerAddress = "127.0.0.1:4444"
--             },
--             {
--                 name = "Attach to Remote LLDB Server",
--                 type = "codelldb",
--                 request = "launch",
--                 program = function()
--                     return vim.fn.input("Path to executable on remote: ", "/opt/code/build/bin/main", "file")
--                 end,
--                 cwd = "${workspaceFolder}",
--                 stopOnEntry = false,
--             },
--
