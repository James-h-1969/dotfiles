require("config.options")
require("config.keymaps")
require("config.lsp")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" })

-- Read PDFs
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local opener = "open"
    if vim.fn.has("wsl") == 1 then
      opener = "explorer.exe"
      path = vim.trim(vim.fn.system({ "wslpath", "-w", path }))
    end
    vim.fn.jobstart({ opener, path }, { detach = true })
    vim.defer_fn(function() vim.cmd("bd!") end, 100)
  end
})

-- Show highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
