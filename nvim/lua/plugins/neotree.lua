return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
        },
        opts = {
            close_if_last_window = true,
            window = {
                position = "left",
                auto_expand_width = true,
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = false,
                    hide_by_name = {
                        -- ".DS_Store",
                        -- "thumbs.db",
                    },
                }
            },
        },
    }
}
