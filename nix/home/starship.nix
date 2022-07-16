{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;

      cmake.symbol = "△ ";
      docker_context.symbol = " ";
      dotnet.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      erlang.symbol = " ";
      golang.symbol = " ";
      helm.symbol = "⎈ ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      terraform.symbol = "𝗧 ";
      vagrant.symbol = "𝗩 ";

      directory = {
        read_only = " ";
        style = "fg:blue";
        truncation_symbol = "…/";
        truncate_to_repo = true;
      };

      git_commit.tag_symbol = " ";
      git_branch = {
        symbol = " ";
        style = "fg:240";
      };

      aws = {
        symbol = "  ";
        region_aliases = {
          eu-central-1 = "eu1";
        };
        profile_aliases = {
          "app-dev-vault" = "**vault";
        };
      };

      gcloud = {
        symbol = " ";
        format = "on [$symbol$project(\($region\))]($style) ";
        region_aliases = {
          us-central1 = "uc1";
        };
      };

      kubernetes = {
        disabled = false;
        symbol = "☸ ";
        context_aliases = {
          "(?P<cluster>[\\\\w-]+).data-platform-cluster" = "$cluster";
        };
      };

      nix_shell = {
        symbol = " ";
        impure_msg = "";
        format = "via [$symbol$name]($style) ";
      };

      battery = {
        full_symbol = "";
        charging_symbol = "";
        discharging_symbol = "";
        unknown_symbol = "";
        empty_symbol = "";
      };

      format = lib.concatStrings [
        # "$username"
        # "$hostname"
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
