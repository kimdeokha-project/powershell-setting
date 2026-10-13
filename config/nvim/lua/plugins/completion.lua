return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        menu = { border = "rounded" },
      },
      signature = { enabled = true },
    },
  },
}
