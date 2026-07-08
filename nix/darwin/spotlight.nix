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
    system.activationScripts.extraActivation.text = ''
      echo "Activating spotlightExclusions" >&2

      # Add noisy developer/cache paths to Spotlight Privacy while preserving
      # exclusions already configured through System Settings.
      spotlight_plist="/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist"
      spotlight_exclusions_changed=0

      add_spotlight_exclusion() {
        local path="$1"

        if [[ ! -e "''${path}" ]]; then
          echo "skipping missing Spotlight exclusion: ''${path}" >&2
          return 0
        fi

        if [[ ! -f "''${spotlight_plist}" ]]; then
          echo "skipping Spotlight exclusions; plist not found: ''${spotlight_plist}" >&2
          return 0
        fi

        /usr/libexec/PlistBuddy -c "Print :Exclusions" "''${spotlight_plist}" >/dev/null 2>&1 \
          || /usr/libexec/PlistBuddy -c "Add :Exclusions array" "''${spotlight_plist}" >/dev/null 2>&1 \
          || {
            echo "unable to read or create Spotlight exclusions array" >&2
            return 0
          }

        if /usr/libexec/PlistBuddy -c "Print :Exclusions" "''${spotlight_plist}" 2>/dev/null \
          | /usr/bin/grep -Fxq "    ''${path}"; then
          return 0
        fi

        if /usr/libexec/PlistBuddy -c "Add :Exclusions: string ''${path}" "''${spotlight_plist}" >/dev/null 2>&1; then
          echo "added Spotlight exclusion: ''${path}" >&2
          spotlight_exclusions_changed=1
        else
          echo "failed to add Spotlight exclusion: ''${path}" >&2
        fi
      }

      ${lib.concatMapStringsSep "\n      " (
        path: "add_spotlight_exclusion ${lib.escapeShellArg path}"
      ) cfg.exclusions}

      if [[ "''${spotlight_exclusions_changed}" == 1 ]]; then
        # Ask Spotlight to reload its metadata configuration. This can fail on
        # some macOS versions because mds is system-protected, so keep it best-effort.
        /bin/launchctl stop com.apple.metadata.mds >/dev/null 2>&1 || true
        /bin/launchctl start com.apple.metadata.mds >/dev/null 2>&1 || true
      fi
    '';
  };
}
