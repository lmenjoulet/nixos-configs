vim.g.mapleader = [[;]]
vim.o.number = true -- show line number
vim.opt.termguicolors = true -- better colors
vim.o.tabstop = 2 -- tab size 2
vim.o.shiftwidth = 0 -- indent size
vim.o.expandtab = true -- convert tab to spaces
vim.o.cursorline = true -- hightlight the line where the cursor is
vim.o.splitright = true -- open new buffer right half of the terminal
vim.o.scrolloff = 999 -- center cursor
vim.o.relativenumber = true -- show relative line number

vim.o.background = [[dark]] -- self explanatory
vim.cmd([[colorscheme gruvbox]]) -- self explanatory

require([[nvim-treesitter.configs]]).setup {
  highlight = {
    enable = true;
  };
}

require([[telescope]]).setup {
  defaults = {
    initial_mode = [[normal]],
    file_ignore_patterns = { [[.git/]], [[node_modules/]] },
  },
  pickers = {
    find_files = {
      hidden = true,
      initial_mode = [[insert]],
    }
  }
}

vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files, { noremap = true })
vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").oldfiles, { noremap = true })
vim.keymap.set("n", "<Leader>fb", require("telescope.builtin").buffers, { noremap = true })
vim.keymap.set("n", "<Leader>ft", require("telescope.builtin").treesitter, { noremap = true })

require([[gitsigns]]).setup {
  current_line_blame = true;
  current_line_blame_opts = {
    delay = 400,
  },
}

require([[nvim-autopairs]]).setup {
  ignored_next_char = "[^%s%]%)%}]"
}

require([[toggleterm]]).setup {
  open_mapping = [[<Leader>t]],
  hide_numbers = true,
  start_in_insert = true,
  direction = [[float]],
}

require("lualine").setup({
  options = {
    icons_enabled = false;
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_c = { "lsp_progress" }
  },
  inactive_sections = {
    lualine_c = {}
  }
})

local lsp_servers = {
  [[bashls]],
  [[rnix]],
  [[ltex]],
  [[rust_analyzer]],
  [[sumneko_lua]]
}

vim.g.coq_settings = {
  auto_start = [[shut-up]],
  display = {
    icons = {
      mode = [[none]]
    }
  },
  xdg = true
}

local lspconfig = require([[lspconfig]])
local coq = require([[coq]])

for _, lsp_server in pairs(lsp_servers) do
  lspconfig[lsp_server].setup(
    coq.lsp_ensure_capabilities()
  )
end

lspconfig.sumneko_lua.setup {
  root_dir = function()
    return vim.loop.cwd()
  end,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      },
    }
  }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  update_in_insert = true,
})

-- format on save

vim.api.nvim_create_autocmd(
  "BufWritePre",
  {
    pattern = "*",
    callback = vim.lsp.buf.formatting_sync
  }
)

-- spell checking and length wrapping for text files

vim.api.nvim_create_autocmd(
  "BufEnter",
  {
    pattern = { "*.txt", "*.tex", "*.md" },
    command = [[set spell spelllang=en_us,fr tw=80 fo+=t fo-=l]]
  }
)
