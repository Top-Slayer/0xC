return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        version = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                settings = {
                    tabline = true,
                },
            })

            -- Keymaps Harpoon
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle menu" })

            vim.keymap.set("n", "<C-P>", function() harpoon:list():prev({ cyclic = true }) end)
            vim.keymap.set("n", "<C-N>", function() harpoon:list():next({ cyclic = true }) end)

            for i = 1, 9 do
                vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon: Go to file " .. i })
            end
        end,
    },
}
