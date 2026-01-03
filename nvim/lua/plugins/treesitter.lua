return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "vim",
                    "hyprlang",
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "c",
                    "lua",
                    "rust",
                    "jsdoc",
                    "bash",
                    "go",
                    "html",
                    "css",
                    "yaml",
                    "json",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}
