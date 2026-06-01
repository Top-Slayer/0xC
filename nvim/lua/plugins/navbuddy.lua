return {
    "neovim/nvim-lspconfig",

    dependencies = {
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim",
            },

            config = function()
                local navbuddy = require("nvim-navbuddy")
                local navic = require("nvim-navic")

                -- Setup navbuddy
                navbuddy.setup({
                    lsp = {
                        auto_attach = true,
                    },
                })

                -- Attach navic to LSP clients
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)

                        if client and client.server_capabilities.documentSymbolProvider then
                            navic.attach(client, args.buf)
                        end
                    end,
                })

                -- Keymap
                vim.keymap.set("n", "<leader>h", function()
                    navbuddy.open()
                end, { desc = "Open Navbuddy" })
            end,
        },
    },
}
