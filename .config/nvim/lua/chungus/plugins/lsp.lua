-- lspconfig just instructs neovim how to talk to whatever server
-- is processing your code. For things like pyright, the server is a
-- node server that is running the pyright package. For things like
-- c/cpp it is talking to a clangd daemon that is running and processing
-- your code. The lspconfig just allows the text editor to talk to it.

-- [[
--      To avoid the mason dependancies, this is how you install each server
--
--      asm
--          cargo install asm-lsp
--
--      c/cpp (needs clangd, clang-tidy, and clang-check)
--          https://clangd.llvm.org/installation#compile_commandsjson
--
--          Bear is used to create the compile_commands.json
--          for the project so that clangd can better understand the project. 
--          You can use it with `bear --make`
--
--              brew install llvm
--              brew install bear
--
--      cmake
--          pip install cmake-language-server
--
--      django (must be in venv)
--          pip install django-template-lsp
--
--      docker
--          npm install @microsoft/compose-language-service
--
--      json
--          npm -i -g vscode-langservers-extracted
--
--      pyright
--          npm -i -g pyright
--
--      robotframework
--          python3 -m pip install robotframework-lsp
--
--
--          
-- ]]

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", buffer=bufnr},
    dependencies = {
        {"hrsh7th/cmp-nvim-lsp"},
        {"antosha417/nvim-lsp-file-operations", config = true},
        {"folke/neodev.nvim", opts = {}},
    },

    config = function()

        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import cmp-nvim-lsp plugin
        
        
        -- [[
        --      Set up keymaps only when the LSP server attaches to the
        --      buffer
        -- ]]
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }
                
                -- jumps
                vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts, {desc="[j]ump [d]efinition"})
                vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, opts, {desc="[j]ump [D]eclaration"})
                
                -- edits
                vim.keymap.set({"n", "v"}, "<leader>ef", vim.lsp.buf.format, opts, {desc="[e]dit [f]format"})
                vim.keymap.set("n", "<leader>er", vim.lsp.buf.rename, opts, {desc="[e]dit [r]ename"}) 
                vim.keymap.set({ "n", "v" }, "<leader>ee", vim.lsp.buf.code_action, opts, {desc="[e]dit [a]ction"})

                -- views
                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "<leader>vs", function() builtin.lsp_document_symbols {symbols={"function", "method"}} end, {desc="[v]iew [s]tructure"})
                vim.keymap.set("n", "<leader>vS", builtin.lsp_document_symbols, {desc="[v]iew all [S]tructure"})
                vim.keymap.set("n", "<leader>VS", builtin.lsp_workspace_symbols, {desc="[V]iew all [S]tructure in project"})
                vim.keymap.set("n", "<leader>vd", vim.lsp.buf.hover, opts, {desc="[v]iew [d]ocs"})
                vim.keymap.set("n", "<leader>vr", builtin.lsp_references, {desc="[V]iew object [r]eferences"})
            end,
        })
        
        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end


        --[[
        -- LSP Language Set Ups // start
        --]]
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Iterate over the list of servers and add the defualts. 
        local lsp_servers = {
            "pyright", 
            "jsonls", 
            "robotframework_ls", 
            "cmake", 
            "asm_lsp",
            "djlsp",
            "docker_compose_language_service",
        }
        for _, lsp_server in ipairs(lsp_servers) do
            lspconfig[lsp_server].setup({
                capabilities = capabilities,
                on_attach = on_attach
            })
        end


        -- Manually set up clangd for more control
        lspconfig.clangd.setup({
            on_attach = on_attach,
            capabilities = capabilities, -- advertise to cmp the lsp info
            filetypes = {"c", "cpp", "h"},
            root_dir = lspconfig.util.root_pattern(
                "compile_commands.json",
                "build/compile_commands.json",
                "compile_flags.txt",
                ".clang-tidy", 
                ".git"
            ),
            cmd = {
                "clangd",
                "--background-index",            -- Keep indexing in the bakcground
                "--clang-tidy",                  -- Enables clang-tidy diagnostics
                "--fallback-style=google",       -- Default style if .clang-tidy is not found
                "--header-insertion=iwyu",       -- include what you use
                "--enable-config",               -- Enables clangd to read project .clang-tidy file
                "--log=verbose",
                "--compile-commands-dir=build",
            },
        })
  end,
}
