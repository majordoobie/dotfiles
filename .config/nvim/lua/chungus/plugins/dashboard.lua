-- cat neovim.cat | lolcat --truecolor --spread=10 --seed=20 --freq=.09 --force > neovim.cat2

return {
    "folke/snacks.nvim",
    opts = {
        dashboard = {
            width = 72,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                {
                    section = "terminal",
                    cmd = "cat " .. vim.fn.stdpath("config") .. "/lua/chungus/plugins/neovim.cat",
                    align = "center",
                    height = 11,
                    width = 72,
                    padding = 0
                },
                { section = "startup" },
                {
                    section = "keys",
                    indent = 1,
                    padding = 1,
                    height = 20,
                },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1},
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            },
            {
                section = 'terminal',
                icon = ' ',
                title = 'Git Status',
                enabled = vim.fn.isdirectory('.git') == 1,
                cmd = 'hub diff --stat -B -M -C',
                height = 8,
                padding = 0,
                indent = 2,
            },
        },
    },
}
