return {
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "famiu/bufdelete.nvim",
        },
        event = "VeryLazy",  -- Load after startup
        keys = {
            { "<C-[>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<C-]>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },

            {
                "<leader>bd", function()
                    require("bufdelete").bufdelete(0, true)
                end,
                desc = "Delete Buffer",
            },
            { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick Close Buffer" },

            { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin Buffer" },
            { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned" },
            { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Others" },
        },
        opts = {
            options = {
                -- Appearance
                separator_style = "slant",
                indicator = { style = "underline" },

                -- Behavior
                always_show_bufferline = false,
                show_buffer_close_icons = false,
                show_close_icon = false,
                diagnostics = "nvim_lsp",

                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { "close" },
                },

                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,

                -- Sidebar offsets
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },

                -- Icons
                get_element_icon = function(element)
                    local icon, hl = require("nvim-web-devicons").get_icon(
                        element.filename,
                        element.extension,
                        { default = true }
                    )
                    return icon, hl
                end,
            },
        },

        config = function(_, opts)
            require("bufferline").setup(opts)
        end,
    },
}
