{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;

      directory = {
        style = "fg:blue";
        truncation_length = 0;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "fg:240";
      };

      aws = {
        format = "on [$symbol$profile] ($style) ";
      };

      gcloud = {
        format = "on [$symbol$project(\($region\))]($style) ";
        region_aliases = {
          us-central1 = "uc1";
        };
      };

      kubernetes = {
        disabled = false;
        symbol = "⛵ ";
        format = "on [$symbol$context(\($namespace\))]($style) ";
      };

      nix_shell = {
        impure_msg = "";
        format = "via [❄️ $state( \($name\))](bold blue) ";
      };

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$dotnet"
        "$elixir"
        "$elm"
        "$golang"
        "$haskell"
        "$java"
        "$nodejs"
        "$python"
        "$ruby"
        "$rust"
        "$kubernetes"
        "$terraform"
        "$nix_shell"
        "$memory_usage"
        "$gcloud"
        "$aws"
        "$env_var"
        "$cmd_duration"
        "$custom"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$character"
      ];
    };
  };
}
