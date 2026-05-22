let custom_completion_commands = {
  k: kubectl
  cfg: git
}

let normalized_external_spans = {|spans|
  let expanded_alias = (
    scope aliases
    | where name == $spans.0
    | get -o 0
    | get -o expansion
  )
  let spans = if $expanded_alias != null {
    ($expanded_alias | split row " ") ++ ($spans | skip 1)
  } else {
    $spans
  }
  let mapped_command = ($custom_completion_commands | get -o ($spans | get 0))

  if $mapped_command != null {
    ($spans | skip 1) | prepend $mapped_command
  } else {
    $spans
  }
}

let ls_path_completer = {|spans|
  let current = ($spans | last)
  let pattern = if $current == "" { "*" } else { $"($current)*" }
  let prefix = if $current == "" {
    ""
  } else if ($current | str ends-with "/") {
    $current
  } else {
    let dirname = ($current | path dirname)
    if $dirname == "" {
      ""
    } else if $dirname == "." {
      "./"
    } else {
      $"($dirname)/"
    }
  }

  glob $pattern
  | each {|entry|
      let entry_type = ($entry | path type)
      let value = $"($prefix)($entry | path basename)"
      {
        value: (if $entry_type == "dir" { $"($value)/" } else { $value })
        description: $entry_type
      }
    }
}

let fish_completer = {|spans|
  if ($spans | is-empty) {
    []
  } else {
    let spans = (do $normalized_external_spans $spans)

    match $spans.0 {
      ls => (do $ls_path_completer $spans)
      _ => (
        fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
        | from tsv --flexible --noheaders --no-infer
        | rename value description
        | update value {|row|
            let value = $row.value
            let need_quote = ['\\' ' ' '[' ']' '(' ')' '\t' "'" '"' '`'] | any { $in in $value }

            if ($need_quote and ($value | path exists)) {
              let expanded_path = if ($value starts-with '~') {
                $value | path expand --no-symlink
              } else {
                $value
              }

              $'"($expanded_path | str replace --all '"' '\\"')"'
            } else {
              $value
            }
          }
      )
    }
  }
}

let completion_menu = {
  name: completion_menu
  only_buffer_difference: false
  marker: ""
  type: {
    layout: columnar
    columns: 4
    col_width: 24
    col_padding: 2
    tab_traversal: "horizontal"
  }
  style: {
    text: white
    selected_text: white_reverse
    description_text: yellow
  }
}

$env.config = ($env.config? | default {})
$env.config.completions = ($env.config.completions? | default {})
$env.config.completions.external = ($env.config.completions.external? | default {})
$env.config.completions.external.completer = $fish_completer
$env.config.menus = (
  $env.config.menus?
  | default []
  | where name != "completion_menu"
  | append $completion_menu
)
