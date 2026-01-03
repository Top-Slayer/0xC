return {
    -- Mason: Install/manage LSP servers, linters, formatters
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- Bridge between Mason and lspconfig
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            -- Auto-install these servers when you open a file of that type
            ensure_installed = {
                "lua_ls",         -- Lua
                "ts_ls",          -- TypeScript/JavaScript
                "pyright",        -- Python
                "rust_analyzer",  -- Rust
                "gopls",          -- Go
                -- Add more as needed: "clangd", "html", "cssls", etc.
            },
            automatic_installation = true,
        },
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },  -- Lazy-load on file open
        dependencies = { "mason-org/mason-lspconfig.nvim" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Common on_attach: keymaps that work when LSP attaches
            local on_attach = function(client, bufnr)
                local bufmap = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                bufmap("n", "gr", vim.lsp.buf.references, "Goto References")
                bufmap("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
                bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
                bufmap("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
                bufmap("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
            end

            -- Setup all installed servers automatically
            require("mason-lspconfig").setup({
                handlers = {
                    -- Default handler for all servers
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    -- Custom handler for lua_ls
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
