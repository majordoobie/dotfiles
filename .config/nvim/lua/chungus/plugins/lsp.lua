-- lspconfig just instructs neovim how to talk to whatever server
-- is processing your code. For things like pyright, the server is a
-- node server that is running the pyright package. For things like
-- c/cpp it is talking to a clangd daemon that is running and processing
-- your code. The lspconfig just allows the text editor to talk to it.


-- pyright
-- * npm -i -g pyright

-- json
-- * npm -i -g vscode-langservers-extracted
--
-- -- cmake
-- pip install cmake-language-server
--
-- -- asm
-- cargo install asm-lsp
--
-- django
-- pip install django-template-lsp (must be in venv)
--
-- docker
-- npm install @microsoft/compose-language-service

-- c/cpp
-- * brew install llvm
-- * brew install bear
--
-- -- https://clangd.llvm.org/installation#compile_commandsjson

-- -- must install clangd and set up the compile_commands.json
-- -- so that clangd can understand your project
-- -- it is recommended to use something like `bear` to build the database
-- -- for make it would be something like `bear -- make`


-- robotframework
-- * python3 -m pip install robotframework-lsp




return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {"hrsh7th/cmp-nvim-lsp"},
        {"antosha417/nvim-lsp-file-operations", config = true},
        {"folke/neodev.nvim", opts = {}},
    },

    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")


        --[[
            -- LSP Language Set Ups // srart
        --]]
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local lsp_servers = {
            "pyright", 
            "clangd", 
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
            })
        end


        lspconfig.clangd.setup({
            cmd = {
                "clangd",
                "--compile-commands-dir=build",  -- Adjust the path to where compile_commands.json is located
                "--enable-config",               -- Enables clangd to read project .clang-tidy file
                "--clang-tidy",                  -- Enables clang-tidy diagnostics
                "--clang-tidy-checks=-*,readability-*,bugprone-*", -- Example of checks you want to enable
                "--fallback-style=google",        -- Default style if .clang-tidy is not found
            },
            root_dir = lspconfig.util.root_pattern(".clang-tidy", ".git", "compile_commands.json"),
        })

      -- c/cpp
      --lspconfig.clangd.setup{}




    -- [[
        -- Specific key bindings go here
    -- ]]
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- jumps
        vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, {desc = "[j]ump [d]efinition"})
        vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, {desc = "[j]ump [D]eclaration"})

        -- edits
        vim.keymap.set("n", "<leader>ef", vim.lsp.buf.format, {desc = "[e]dit [f]format"})

        -- set keybinds
        opts.desc = "Show LSP references"
        vim.keymap.set("n", "<leader>jr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references


        opts.desc = "Show LSP implementations"
        vim.keymap.set("n", "<leader>ju", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>er", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>vD", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "vd", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        opts.desc = "View file structure"
        vim.keymap.set("n", "<leader>vs", "<cmd>Telescope lsp_document_symbols symbols='function'<CR>", opts) -- mapping to restart lsp if necessary

      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

  end,
}
