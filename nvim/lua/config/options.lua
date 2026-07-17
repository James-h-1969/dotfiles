vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.autoread = true

-- Don't auto-continue comments on Enter (except cpp/c)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "cpp" and ft ~= "c" then
      vim.opt_local.formatoptions:remove({ "r", "o" })
    end
  end,
})

vim.filetype.add({ extension = { typ = "typst" } })

-- Add a line length warning 
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "c"},
    callback = function()
        vim.opt_local.colorcolumn = "80"
        vim.opt_local.formatoptions:append({ "r" })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python"},
    callback = function()
        vim.opt_local.colorcolumn = "80"
    end
})
