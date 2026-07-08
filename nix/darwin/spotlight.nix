{ config, lib, ... }:
let
  cfg = config.custom.spotlight;
in
{
  options.custom.spotlight = {
    enable = lib.mkEnableOption "Spotlight developer path exclusions";

    exclusions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Paths to add to Spotlight Privacy. Existing manual exclusions are preserved.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.postActivation.text = ''
      # Add noisy developer/cache paths to Spotlight Privacy while preserving
      # exclusions already configured through System Settings.
      spotlight_plist="/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist"

      add_spotlight_exclusion() {
        local path="$1"

        [[ -e "''${path}" ]] || return 0
        [[ -f "''${spotlight_plist}" ]] || return 0

        /usr/libexec/PlistBuddy -c "Print :Exclusions" "''${spotlight_plist}" >/dev/null 2>&1 \
          || /usr/libexec/PlistBuddy -c "Add :Exclusions array" "''${spotlight_plist}" >/dev/null 2>&1 \
          || return 0

        if /usr/libexec/PlistBuddy -c "Print :Exclusions" "''${spotlight_plist}" 2>/dev/null \
          | /usr/bin/grep -Fxq "    ''${path}"; then
          return 0
        fi

        /usr/libexec/PlistBuddy -c "Add :Exclusions: string ''${path}" "''${spotlight_plist}" >/dev/null 2>&1 || true
      }

      ${lib.concatMapStringsSep "\n      " (
        path: "add_spotlight_exclusion ${lib.escapeShellArg path}"
      ) cfg.exclusions}

      # Ask Spotlight to reload its metadata configuration. This can fail on
      # some macOS versions because mds is system-protected, so keep it best-effort.
      /bin/launchctl stop com.apple.metadata.mds >/dev/null 2>&1 || true
      /bin/launchctl start com.apple.metadata.mds >/dev/null 2>&1 || true
    '';
  };
}
