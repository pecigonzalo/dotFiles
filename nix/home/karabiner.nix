{ ... }:

let
  # Terminal emulators and apps where Ctrl should NOT be remapped
  excludedApps = [
    "^org\\.vmware\\.fusion$"
    "^com\\.vmware\\.view$"
    "^com\\.vmware\\.proxyApp\\."
    "^com\\.vmware\\.horizon$"
    "^org\\.virtualbox\\.app\\.VirtualBoxVM$"
    "^com\\.apple\\.Terminal$"
    "^com\\.github\\.wez\\.wezterm$"
    "^com\\.googlecode\\.iterm2$"
    "^io\\.alacritty$"
    "^net\\.kovidgoyal\\.kitty$"
    "^com\\.thinomenon\\.RemoteDesktopConnection$"
    "^com\\.parallels\\.winapp\\."
    "^com\\.parallels\\.vm$"
    "^com\\.parallels\\.desktop$"
    "^com\\.parallels\\.desktop\\.console$"
    "^com\\.microsoft\\.VSCode$"
    "^com\\.microsoft\\.rdc$"
    "^com\\.microsoft\\.rdc\\.macos$"
    "^com\\.microsoft\\.rdc\\."
    "^com\\.jetbrains.*$"
    "^tv\\.parsec\\.www$"
  ];

  # Terminal emulators only (for Ctrl+Shift remaps)
  terminalApps = [
    "^com\\.apple\\.Terminal$"
    "^com\\.github\\.wez\\.wezterm$"
    "^com\\.googlecode\\.iterm2$"
    "^io\\.alacritty$"
    "^net\\.kovidgoyal\\.kitty$"
  ];

  # Keys to remap from Ctrl to Cmd
  ctrlKeys = [
    "w"
    "n"
    "t"
    "c"
    "x"
    "z"
    "v"
    "f"
    "a"
  ];

  # Generate manipulator for Ctrl → Cmd
  mkCtrlManipulator = key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        mandatory = [ "control" ];
      };
    };
    to = [
      {
        key_code = key;
        modifiers = [ "command" ];
      }
    ];
  };

  # Generate manipulator for Ctrl+Shift → Cmd (terminals only)
  mkCtrlShiftManipulator = key: {
    type = "basic";
    conditions = [
      {
        type = "frontmost_application_if";
        bundle_identifiers = terminalApps;
      }
      {
        type = "variable_if";
        name = "hyper_mode";
        value = 0;
      }
    ];
    from = {
      key_code = key;
      modifiers = {
        mandatory = [
          "control"
          "shift"
        ];
      };
    };
    to = [
      {
        key_code = key;
        modifiers = [ "command" ];
      }
    ];
  };

  karabinerConfig = {
    profiles = [
      {
        name = "Empty";
        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
      {
        name = "Current";
        selected = true;
        virtual_hid_keyboard = {
          country_code = 1;
          keyboard_type_v2 = "ansi";
        };

        complex_modifications = {
          rules = [
            # Consolidated Ctrl → Cmd remapping
            {
              description = "Ctrl → Cmd (disabled during Hyper)";
              conditions = [
                {
                  type = "frontmost_application_unless";
                  bundle_identifiers = excludedApps;
                }
                {
                  type = "variable_if";
                  name = "hyper_mode";
                  value = 0;
                }
              ];
              manipulators =
                # Basic Ctrl → Cmd for all keys
                (map mkCtrlManipulator ctrlKeys)
                # Terminal-specific Ctrl+Shift → Cmd
                ++ (map mkCtrlShiftManipulator [
                  "c"
                  "v"
                ]);
            }

            # Home/End remapping
            {
              description = "End";
              manipulators = [
                {
                  type = "basic";
                  conditions = [
                    {
                      type = "frontmost_application_unless";
                      bundle_identifiers = excludedApps;
                    }
                  ];
                  from = {
                    key_code = "end";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to = [
                    {
                      key_code = "right_arrow";
                      modifiers = [ "command" ];
                    }
                  ];
                }
              ];
            }

            {
              description = "Home";
              manipulators = [
                {
                  type = "basic";
                  conditions = [
                    {
                      type = "frontmost_application_unless";
                      bundle_identifiers = excludedApps;
                    }
                  ];
                  from = {
                    key_code = "home";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to = [
                    {
                      key_code = "left_arrow";
                      modifiers = [ "command" ];
                    }
                  ];
                }
              ];
            }

            # Caps Lock → Hyper Key
            {
              description = "Caps Lock → Hyper Key (⌃⌥⇧⌘) | Escape if alone | Use fn + caps lock to enable caps lock";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                  };
                  to = [
                    {
                      set_variable = {
                        name = "hyper_mode";
                        value = 1;
                      };
                    }
                    {
                      key_code = "left_shift";
                      modifiers = [
                        "left_command"
                        "left_control"
                        "left_option"
                      ];
                    }
                  ];
                  to_after_key_up = [
                    {
                      set_variable = {
                        name = "hyper_mode";
                        value = 0;
                      };
                    }
                  ];
                  to_if_alone = [
                    {
                      key_code = "escape";
                    }
                  ];
                }
              ];
            }
          ];
        };

        # Device-specific configurations
        devices = [
          # Razer keyboards (ignore)
          {
            identifiers = {
              is_keyboard = true;
              product_id = 126;
              vendor_id = 5426;
            };
            ignore = true;
            manipulate_caps_lock_led = false;
          }
          {
            identifiers = {
              is_keyboard = true;
              product_id = 136;
              vendor_id = 5426;
            };
            ignore = true;
            manipulate_caps_lock_led = false;
          }
          {
            identifiers = {
              is_keyboard = true;
              product_id = 134;
              vendor_id = 5426;
            };
            ignore = true;
          }

          # Apple keyboard (ignore)
          {
            identifiers = {
              is_keyboard = true;
              product_id = 34304;
              vendor_id = 1452;
            };
            ignore = true;
          }

          # Generic keyboard - ISO to ANSI layout fix
          {
            identifiers = {
              is_keyboard = true;
            };
            simple_modifications = [
              {
                from = {
                  key_code = "grave_accent_and_tilde";
                };
                to = [
                  {
                    key_code = "left_shift";
                  }
                ];
              }
              {
                from = {
                  key_code = "non_us_backslash";
                };
                to = [
                  {
                    key_code = "grave_accent_and_tilde";
                  }
                ];
              }
            ];
          }

          # Specific devices - Caps Lock to F18
          {
            identifiers = {
              is_keyboard = true;
              is_pointing_device = true;
              product_id = 41619;
              vendor_id = 1241;
            };
            simple_modifications = [
              {
                from = {
                  key_code = "caps_lock";
                };
                to = [
                  {
                    key_code = "f18";
                  }
                ];
              }
            ];
          }
          {
            identifiers = {
              is_keyboard = true;
              product_id = 61664;
              vendor_id = 13;
            };
            simple_modifications = [
              {
                from = {
                  key_code = "caps_lock";
                };
                to = [
                  {
                    key_code = "f18";
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };

in
{
  # Symlink the generated Karabiner config
  home.file.".config/karabiner/karabiner.json" = {
    text = builtins.toJSON karabinerConfig;
  };
}
