{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.paths;
in
{
  options.my.paths = {
    homeDir = mkOption {
      type = types.str;
      readOnly = true;
      default = config.home.homeDirectory;
      description = "User's home directory (read-only)";
    };

    dotFilesDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/dotFiles";
      description = "Path to the dotfiles repository directory";
    };

    workspaceDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Workspace";
      description = "Path to the workspace directory for projects";
    };

    mkDotFileLink = mkOption {
      type = types.functionTo types.path;
      readOnly = true;
      default = path: config.lib.file.mkOutOfStoreSymlink "${cfg.dotFilesDir}/${path}";
      description = "Helper function to create out-of-store symlinks to dotfiles";
    };
  };
}
