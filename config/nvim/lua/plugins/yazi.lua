return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Yazi at current file",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Yazi at working directory",
      },
      {
        "<leader>-",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume Yazi session",
      },
    },
    opts = {
      open_for_directories = true,
      change_neovim_cwd_on_close = true,
      floating_window_scaling_factor = 0.92,
      yazi_floating_window_winblend = 0,
      yazi_floating_window_border = "rounded",
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
