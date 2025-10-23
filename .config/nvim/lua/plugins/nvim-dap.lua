-- To tell Neovim if it should launch a debug adapter or connect to one, and if
-- so, how, you need to configure them via the `dap.adapters` table. The key of
-- the table is an arbitrary name that debug adapters are looked up by when using
-- a |dap-configuration|.
--
-- The dap-configuration does need to match the filetype you are configuring

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- Optional: Provides a UI for nvim-dap
		"theHamsta/nvim-dap-virtual-text", -- Optional: Shows virtual text for current frame variables
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("nvim-dap-virtual-text").setup({
            commented = true
        })
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

		-- ══════════════════════════════════════════════════════════════
		-- 🐛 Debugging Controls
		-- ══════════════════════════════════════════════════════════════
		vim.keymap.set("n", "<F12>", dap.step_over, { desc = "⏭️  Step over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "⬇️  Step into" })
		vim.keymap.set("n", "<F10>", dap.step_out, { desc = "⬆️  Step out" })

		-- Breakpoints
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "🔴 Toggle breakpoint"})
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "🔶 Conditional breakpoint" })

		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "📝 Log point" })

		-- Debugging UI
		vim.keymap.set("n", "<leader>dor", dap.repl.open, { desc = "💬 Open REPL" })

		local dap_widget = require("dap.ui.widgets")

		vim.keymap.set("n", "<Leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end, { desc = "📚 Stack frames" })

		vim.keymap.set("n", "<Leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, { desc = "🔍 Scopes" })

		vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
			require("dap.ui.widgets").hover()
		end, { desc = "👁️  Hover evaluate" })

		vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
			require("dap.ui.widgets").preview()
		end, { desc = "👀 Preview value" })

		-- Session Control
		vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "⏹️  Terminate session" })
		vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "🔄 Restart session" })
		vim.keymap.set("n", "<leader>dd", dap.continue, { desc = "▶️  Continue/Start" })
		vim.keymap.set("n", "<leader>do", dapui.open, { desc = "📂 Open DAP UI" })
		vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "❌ Close DAP UI" })

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
				args = { "-h" },
				initCommands = {
					-- "log enable lldb default conn host comm",
					"log enable lldb breakpoint command",
					"platform select remote-linux",
					"platform connect connect://127.0.0.1:4444",
					"settings set target.inherit-env false",
					"settings set target.source-map /opt/code ${workspaceFolder}",
				},
			},
		}

		dap.adapters.python = {
			type = "executable",
			command = "python", -- or use the full path to your Python interpreter
			args = { "-m", "debugpy.adapter" },
		}

		-- Configure debugging configurations for Python files.
		dap.configurations.python = {
			{
				type = "python", -- matches the adapter definition
				request = "launch",
				name = "Launch file",
				program = "${file}", -- This configuration will debug the current file
				pythonPath = function()
					-- Use the virtualenv if it exists, otherwise fallback to system python.
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						return cwd .. "/venv/bin/python"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						return cwd .. "/.venv/bin/python"
					else
						return "python"
					end
				end,
			},
		}


		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c
	end,
}
