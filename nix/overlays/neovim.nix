final: prev:
{
  tree-sitter = prev.tree-sitter.override {
    extraGrammars = {
      tree-sitter-kotlin = {
        url = "https://github.com/fwcd/tree-sitter-kotlin";
        rev = "b953dbdd05257fcb2b64bc4d9c1578fac12e3c28";
        sha256 = "sha256-xTbRn7bDN6FR9UOzw43RVHIahI/DFjwLGQj3cYoPurY=";
        fetchSubmodules = false;
      };
      tree-sitter-sql = {
        url = "https://github.com/derekstride/tree-sitter-sql";
        rev = "70c50264ae022193adb364ffa7a767d765ed9857";
        sha256 = "sha256-0HlkjL+Wy82SmVLSPXL7o3Y3l/zSDaPeBygLSvdCRZs=";
        fetchSubmodules = false;
      };
      tree-sitter-rust = {
        url = "https://github.com/tree-sitter/tree-sitter-rust";
        rev = "0431a2c60828731f27491ee9fdefe25e250ce9c9";
        sha256 = "sha256-DnUq8TwLGPtN1GXw0AV2t+tj7UKrU4kU32rjGoCHMpE=";
        fetchSubmodules = false;
      };
      tree-sitter-bash = {
        url = "https://github.com/tree-sitter/tree-sitter-bash";
        rev = "77cf8a7cab8904baf1a721762e012644ac1d4c7b";
        sha256 = "sha256-UPMJ7iL8Y0NkAHtPDrkTjG1qFwr8rXuGqvsG+LTWqEY=";
        fetchSubmodules = false;
      };
    };
  };
}
