return {
    {
        "fooktu/tokyo-dark-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyo-dark").setup({
                terminal_colors = true,
                italic_comments = true,
                italic_keywords = true,
            })
            vim.cmd("colorscheme tokyo-dark")
        end,
    }
}
