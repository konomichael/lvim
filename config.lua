-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.transparent_window = true
lvim.colorscheme = "catppuccin"
vim.opt.relativenumber = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = "120"
-- KeyMappings
lvim.keys.insert_mode['jk'] = "<Esc>"
lvim.keys.normal_mode['<S-l>'] = ":BufferLineCycleNext<Enter>"
lvim.keys.normal_mode['<S-h>'] = ":BufferLineCyclePrev<Enter>"
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.lua", "*.py", "*.cc", "*.h" }
-- Color
lvim.autocommands = {
  {
    { "ColorScheme" },
    {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
      end,
    },
  },
}
-- Linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "cppcheck" },
  { name = "flake8",  args = { "--max-line-length", "120" } }
}
-- Formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "clang_format" },
  { name = "autopep8",    args = { "--max-line-length", "120", "--experimental" } }
}
-- plugins
lvim.plugins = {
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        integrations = {
          alpha = true,
          gitsigns = true,
          harpoon = true,
          hop = true,
          lightspeed = true,
          mason = true,
          cmp = true,
          nvimtree = true,
          treesitter = true,
          treesitter_context = true,
          telescope = true,
          illuminate = true,
          which_key = true
        },
      })
    end
  }
}
