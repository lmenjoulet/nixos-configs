vim.g.mapleader = [[;]]
vim.o.number = true -- show line number
vim.opt.termguicolors = true -- better colors
vim.o.laststatus = 3
vim.o.tabstop = 2 -- tab size 2
vim.o.shiftwidth = 0 -- indent size
vim.o.expandtab = true -- convert tab to spaces
vim.o.cursorline = true -- hightlight the line where the cursor is
vim.o.splitright = true -- open new buffer right half of the terminal
vim.o.scrolloff = 999 -- center cursor
vim.o.relativenumber = true -- show relative line number
vim.o.signcolumn = [[yes]] -- 
vim.o.background = [[dark]] -- self explanatory
vim.cmd([[colorscheme gruvbox]]) -- self explanatory

require([[nvim-treesitter.configs]]).setup {
  highlight = {
    enable = true;
  };
}

-- Session/project manager

require("project_nvim").setup {}

-- Telescope

require([[telescope]]).setup {
  defaults = {
    initial_mode = [[normal]],
    file_ignore_patterns = { [[.git/]], [[node_modules/]], [[compilation_output/]] },
  },
  pickers = {
    find_files = {
      hidden = true,
      initial_mode = [[insert]],
    },
    current_buffer_fuzzy_find = {
      initial_mode = [[insert]],
    }
  }
}

require('telescope').load_extension('projects')


vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files, { noremap = true })
vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").oldfiles, { noremap = true })
vim.keymap.set("n", "<Leader>fb", require("telescope.builtin").buffers, { noremap = true })
vim.keymap.set("n", "<Leader>ft", require("telescope.builtin").current_buffer_fuzzy_find, { noremap = true })
vim.keymap.set("n", "<Leader>fe", require("telescope.builtin").diagnostics, { noremap = true })
vim.keymap.set("n", "<Leader>fw", require("telescope.builtin").spell_suggest, { noremap = true })
vim.keymap.set("n", "<Leader>fp", require("telescope").extensions.projects.projects, { noremap = true })


-- Start Menu

local dashboard = require("alpha.themes.dashboard");

dashboard.text = function (txt, hl_group, position)
  return {
    type = "text",
    val = txt,
    opts = {
      hl = hl_group,
      position = position
    };
  }
end;

dashboard.section.header.val = {
  "                    (//////                    ",
  "                  .((((/////                   ",
  "                 (((((((//////                 ",
  "                (((((((((//////                ",
  "              ((((((*((((((//////              ",
  "             ((((((****(((((//////             ",
  "           ((((((****** ((((((//////           ",
  "          ((((((*****    ((((((//////          ",
  "        ((((((******       ((((((//////        ",
  "       ((((((*****/         ((((((//////       ",
  "     ((((((******   NEOVIM    (((((//////      ",
  "    ((((((******               ((((((//////    ",
  "   ((((((*****//////////////////////////////   ",
  " ((((((******///////////////////////////////// ",
  "((((((*****************************************",
  " ((*****************************************   ",
  "  (**************************************      ",
}

dashboard.section.buttons.val = {
    dashboard.text("=====================================================", "GruvboxAqua", "center"),
    dashboard.button("e", "|>   New file", ":enew <CR>"),
    dashboard.button("t", "|>   Open terminal", ":ToggleTerm<CR>"),
    dashboard.button("p", "|>   Open Project", ":Telescope projects<CR>"),
    dashboard.button("q", "|>   Quit", ":qa<CR>")
};


dashboard.section.footer.type = "group";

dashboard.section.footer.val = {
  dashboard.text("=====================================================", "GruvboxAqua", "center"),
  dashboard.text("Do you think aliens watch us boil water all day while", "GruvboxFg4",  "center"),
  dashboard.text("searching for new ways to boil even more water and   ", "GruvboxFg4",  "center"),
  dashboard.text("just laugh at how fucking shit we are?               ", "GruvboxFg4",  "center"),
  dashboard.text(">*puts pan of water on stove*                        ", "GruvboxGreen","center"),
  dashboard.text(">look at me, I'm a human!                            ", "GruvboxGreen","center"),
  dashboard.text("                                               - Anon", "GruvboxFg4",  "center"),
  dashboard.text("=====================================================", "GruvboxAqua", "center"),
}

require("alpha").setup(dashboard.opts)
-- Git integration
require([[gitsigns]]).setup {
  current_line_blame = true;
  current_line_blame_opts = {
    delay = 400,
  },
}

require([[diffview]]).setup ({
  use_icons = false;
})

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
    lualine_c = { "lsp_progress" },
    lualine_x = { "buffers" },
    lualine_y = { { "filename", path = 1 } }
  },
})

local lsp_servers = {
  [[bashls]],
  [[rnix]],
  [[ltex]],
  [[quick_lint_js]],
  [[texlab]],
  [[erlangls]],
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
  xdg = true,
  clients = {
    buffers = {
      enabled = false,
    },
  },
}

local lspconfig = require([[lspconfig]])
local coq = require([[coq]])

for _, lsp_server in pairs(lsp_servers) do
  lspconfig[lsp_server].setup(
    coq.lsp_ensure_capabilities()
  )
end

-- Custom spell check and latex config

local dico_location = os.getenv("HOME").."/Documents/Ressources/vim-dictionnaire.add"

vim.cmd([[set spellfile=]] .. dico_location)
vim.cmd([[set spelllang=fr]])

lspconfig.ltex.setup {
    root_dir = function()
      return vim.loop.cwd()
    end,
    settings = {
      ltex = {
        language = "fr",
        completionEnabled = true,
        dictionary = {
          ["fr"] = (function(file)
            local dict = {}
            for line in io.lines(file) do
              table.insert(dict, line)
            end
            return dict
          end)(dico_location)
        }
      }
  }
}

lspconfig.texlab.setup {
  settings = {
    texlab = {
      rootDirectory = vim.loop.cwd(),
      auxDir = "compilation_output",
      build = {
        onSave = true,
        args = {
          "-pdf",
          "-outdir=compilation_output",
          "-bibtexfudge-",
          "%f",
        }
      }
    }
  }
}

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
    callback = vim.lsp.buf.format
  }
)

-- length wrapping for text files

vim.api.nvim_create_autocmd(
  "BufEnter",
  {
    pattern = { "*.txt", "*.tex", "*.md" },
    command = [[set tw=80 fo+=t fo-=l]]
  }
)
