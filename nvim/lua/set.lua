vim.opt.scrolloff = 10

local view_group = vim.api.nvim_create_augroup("PersistBufferView", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
    group = view_group,
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        vim.b[args.buf].last_view = vim.fn.winsaveview()
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = view_group,
    callback = function(args)
        local view = vim.b[args.buf].last_view

        if not view or vim.bo[args.buf].buftype ~= "" then
            return
        end

        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_get_current_buf() == args.buf then
                pcall(vim.fn.winrestview, view)
            end
        end)
    end,
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.opt.termguicolors = true

-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")
--
-- vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "100"
