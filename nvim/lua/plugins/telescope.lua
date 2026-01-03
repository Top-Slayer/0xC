return {
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.2.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        cmd = "Telescope",  -- Lazy-load on command
        keys = {
            -- Common keymaps (feel free to change <leader>)
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (search text)" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    prompt_prefix = "> ",
                    selection_caret = "➜ ",
                    path_display = { "smart" },
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                            ["<C-q>"] = "close",
                        },
                        n = {
                            ["q"] = "close",
                        },
                    },
                },
                pickers = {
                    find_files = { 
                        hidden = true,
                        no_ignore = true,
                        file_ignore_patterns = {},
                    },
                    live_grep = { 
                        additional_args = { 
                            "--hidden", 
                            "--no-ignore" 
                        } 
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")
        end,
    },
}
