vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  settings = {
    python = {
      pythonPath = "/Library/Developer/CommandLineTools/usr/bin/python3",
    },
  },
})
vim.lsp.enable("pyright")

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})
vim.lsp.enable("ruff")

vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { "typst.toml", ".git" },
  init_options = {
    typstExtraArgs = { "--root", "/Users/james.hocking/thesis" },
  },
})
vim.lsp.enable("tinymist")

vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".clangd", ".git" },
})
vim.lsp.enable("clangd")

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
})
vim.lsp.enable("ts_ls")

-- Show diagnostic message in a floating window when cursor is on an error
vim.diagnostic.config({
  virtual_text = false,
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- How long (ms) cursor must be still before CursorHold fires (default 4000 is too slow)
vim.opt.updatetime = 300