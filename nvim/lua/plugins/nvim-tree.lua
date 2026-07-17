return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      view = { adaptive_size = true },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Wrap vim.keymap.set to skip mappings with nil rhs (compat with newer nvim-tree)
        local original_set = vim.keymap.set
        vim.keymap.set = function(mode, lhs, rhs, map_opts)
          if rhs ~= nil then
            original_set(mode, lhs, rhs, map_opts)
          end
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set = original_set
        local function opts(desc)
          return { buffer = bufnr, noremap = true, silent = true, desc = desc }
        end
        vim.keymap.set("n", "]r", function()
          local node = api.tree.get_node_under_cursor()
          if node and node.parent and node.parent.parent then
            while node.parent and node.parent.parent do
              api.node.navigate.parent()
              node = api.tree.get_node_under_cursor()
            end
          end
          api.node.navigate.sibling.next()
        end, opts("Next root-level item"))
        vim.keymap.set("n", "[r", function()
          local node = api.tree.get_node_under_cursor()
          if node and node.parent and node.parent.parent then
            while node.parent and node.parent.parent do
              api.node.navigate.parent()
              node = api.tree.get_node_under_cursor()
            end
          end
          api.node.navigate.sibling.prev()
        end, opts("Prev root-level item"))
      end,
    })
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
  end,
}
