{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      coq_nvim
      coq-artifacts
      gitsigns-nvim
      gruvbox-nvim
      lualine-lsp-progress
      lualine-nvim
      nvim-autopairs
      nvim-lspconfig
      plenary-nvim
      telescope-nvim
      toggleterm-nvim
      diffview-nvim
      alpha-nvim 
      project-nvim
    ];
    extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
    extraPackages = with pkgs; [
      universal-ctags
      quick-lint-js
      rnix-lsp
      sumneko-lua-language-server
      ltex-ls
      texlab
    ];
  };
}

