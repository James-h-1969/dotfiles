return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter",
  opts = {
    ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css", "json", "yaml", "bash", "markdown", "typst", "cpp", "c" },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
