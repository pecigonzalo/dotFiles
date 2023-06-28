final: prev:
{
  # Example of custom plugin
  go-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
    pname = "go.nvim";
    version = "793b0d1ede7693952644c8655bba1edc243a450f";
    src = prev.fetchFromGitHub {
      owner = "ray-x";
      repo = "go.nvim";
      rev = "793b0d1ede7693952644c8655bba1edc243a450f";
      hash = "sha256-TvUFhwfd1u28q3aTQYKnwt15oiVPHtxcRDUY/ymwC/M=";
    };
  };
  gopher-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
    pname = "gopher.nvim";
    version = "03cabf675ce129c28bd855969a3e569edcf63366";
    src = prev.fetchFromGitHub {
      owner = "olexsmir";
      repo = "gopher.nvim";
      rev = "03cabf675ce129c28bd855969a3e569edcf63366";
      hash = "sha256-GeMvWb/5/e9TMycPNKS+ZvY8ODiWJA7wvP5wan+9CL4=";
    };
  };
  nvim-treesitter-textobjects = prev.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-treesitter-textobjects";
    version = "23e883b99228f8d438254e5ef8c897e5e60e75d1";
    src = prev.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-textobjects";
      rev = "23e883b99228f8d438254e5ef8c897e5e60e75d1";
      sha256 = "sha256-SE9oKrGezJ5a3KsrIaHXJbQnaHX+NEgD2LKa9ABUXPY=";
    };
  };
  nvim-lsp-notify = prev.vimUtils.buildVimPluginFrom2Nix
    {
      pname = "nvim-lsp-notify";
      version = "9986955e0423f2f5cdb3bd4f824bc980697646a0";
      src = prev.fetchFromGitHub {
        owner = "mrded";
        repo = "nvim-lsp-notify";
        rev = "9986955e0423f2f5cdb3bd4f824bc980697646a0";
        sha256 = "sha256-J6PRYS62r4edMO6UDZKrOv2x6RFox5k3pqvVqlnz6hs";
      };
    };
  # Example of updating or adding garmmars
  tree-sitter = prev.tree-sitter.override {
    extraGrammars = {
      # tree-sitter-kotlin = {
      #   url = "https://github.com/fwcd/tree-sitter-kotlin";
      #   rev = "e4637037a5fe6f25fe66c305669faa0855f35692";
      #   sha256 = "";
      #   fetchSubmodules = false;
      # };
    };
  };
}
