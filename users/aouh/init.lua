-- options

vim.o.hidden = true
vim.o.number = true
vim.opt.termguicolors = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.splitright = true
vim.o.signcolumn = "yes"
vim.o.conceallevel = 2
vim.o.concealcursor = "nc"
vim.o.updatetime = 300
vim.opt.shortmess:append({ c = true })
vim.o.scrolloff = 999
vim.o.relativenumber = true
vim.g.mapleader = ";"
vim.o.pumheight = 10;

--- color scheme

vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

require("gruvbox").setup {
  contrast = "hard",
}

--- TreeSitter

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
})


--- lsp config

local on_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

local cmp = require "cmp"

cmp.setup({
  completion = {
    completeopt = 'menu, menuone, noinsert'
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer" }
  }),
  preselect = cmp.PreselectMode.None,
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
  })
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" }
  })
})

require("nvim-autopairs").setup {}
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done()
)

local lspconfig = require("lspconfig")

local lsp_servers = {
  "rnix",
  "bashls",
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lang in pairs(lsp_servers) do
  lspconfig[lang].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  update_in_insert = true,
})

lspconfig.sumneko_lua.setup {
  root_dir = function()
    return vim.loop.cwd()
  end,
  on_attach = on_attach,
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

-- autoformat

vim.api.nvim_create_autocmd("BufWritePre",
  { pattern = "*", callback = vim.lsp.buf.formatting_sync }
)

--- Terminal mappings

require("toggleterm").setup {
  open_mapping = "<Leader>t",
  hide_numbers = true,
  start_in_insert = true,
  direction = "float",
  shade_terminals = false,
}

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { noremap = true })

--- Line

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

--- Telescope

require("telescope").setup {
  defaults = {
    initial_mode = "normal",
    file_ignore_patterns = { ".git/", "node_modules/" },
  },
  pickers = {
    find_files = {
      hidden = true,
      initial_mode = "insert",
    }
  }

}

vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files, { noremap = true })
vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").oldfiles, { noremap = true })
vim.keymap.set("n", "<Leader>fb", require("telescope.builtin").buffers, { noremap = true })
vim.keymap.set("n", "<Leader>ft", require("telescope.builtin").treesitter, { noremap = true })
vim.keymap.set("n", "<Leader>fe", require("telescope.builtin").diagnostics, { noremap = true })
vim.keymap.set("n", "<Leader>fs", require("telescope.builtin").lsp_document_symbols, { noremap = true })


-- Gitsigns

require('gitsigns').setup {}

-- Neogit

require('neogit').setup {}

vim.keymap.set("n", "<Leader>gc", function()
  require('neogit').open({ "commit" })
end, { noremap = true })

vim.keymap.set("n", "<Leader>gv", function()
  require('neogit').open()
end, { noremap = true })
