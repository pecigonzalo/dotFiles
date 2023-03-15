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
