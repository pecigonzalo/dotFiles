def --wrapped forgit [...args] {
  let forgit_dir = ($env.HOME | path join ".config" "zsh" "plugins" "forgit")
  let forgit_cmd = ($forgit_dir | path join "bin" "git-forgit")

  with-env { FORGIT_INSTALL_DIR: $forgit_dir } {
    run-external $forgit_cmd ...$args
  }
}

def --wrapped gam [...args] {
  let gam_cmd = ($env.HOME | path join "bin" "gam" "gam")
  run-external $gam_cmd ...$args
}

def k_supports_structured_output [args: list<string>] {
  let subcommand = ($args | get -o 0)
  let nested_subcommand = ($args | get -o 1)
  let has_output_flag = ($args | any {|arg| ($arg | str starts-with "-o") or ($arg == "--output") or ($arg | str starts-with "--output=") })
  let has_streaming_flag = ($args | any {|arg| $arg in ["-w" "--watch" "--watch-only"] })

  ((not $has_output_flag) and (not $has_streaming_flag) and ($subcommand == "get" or ($subcommand == "config" and $nested_subcommand == "view")))
}

def --wrapped k [--raw, ...args] {
  if ($args | is-empty) {
    ^kubectl
  } else if ((not $raw) and (k_supports_structured_output $args)) {
    ^kubectl ...$args -o json | from json
  } else {
    ^kubectl ...$args
  }
}

def ex [file: path] {
  let archive = ($file | path expand)

  if not ($archive | path exists) {
    error make { msg: $"'($file)' is not a valid file" }
  }

  if ($archive | str ends-with ".tar.bz2") {
    ^tar xvjf $archive
  } else if ($archive | str ends-with ".tar.gz") {
    ^tar xvzf $archive
  } else if ($archive | str ends-with ".tar.xz") {
    ^tar xvJf $archive
  } else if ($archive | str ends-with ".tar.lzma") {
    ^tar --lzma xvf $archive
  } else if ($archive | str ends-with ".bz2") {
    ^bunzip2 $archive
  } else if ($archive | str ends-with ".rar") {
    ^unrar x $archive
  } else if ($archive | str ends-with ".gz") {
    ^gunzip $archive
  } else if ($archive | str ends-with ".tar") {
    ^tar xvf $archive
  } else if ($archive | str ends-with ".tbz2") {
    ^tar xvjf $archive
  } else if ($archive | str ends-with ".tgz") {
    ^tar xvzf $archive
  } else if ($archive | str ends-with ".zst") {
    ^tar --zstd -xvf $archive
  } else if ($archive | str ends-with ".zip") {
    ^unzip $archive
  } else if ($archive | str ends-with ".Z") {
    ^uncompress $archive
  } else if ($archive | str ends-with ".7z") {
    ^7z x $archive
  } else if ($archive | str ends-with ".xz") {
    ^xz -dkv $archive
  } else if ($archive | str ends-with ".dmg") {
    ^hdiutil mount $archive
  } else {
    error make { msg: $"'($file)' cannot be extracted via ex" }
  }
}

def clipcopy [file?: path] {
  let content = if $file == null {
    $in | into string
  } else {
    open --raw $file
  }

  match $nu.os-info.name {
    "macos" => { $content | ^pbcopy }
    "linux" => {
      if ((which clip.exe | is-not-empty)) {
        $content | ^clip.exe
      } else if ((which xclip | is-not-empty)) {
        $content | ^xclip -in -selection clipboard
      } else if ((which xsel | is-not-empty)) {
        $content | ^xsel --clipboard --input
      } else {
        error make { msg: "clipcopy: no supported clipboard tool found" }
      }
    }
    _ => {
      error make { msg: $"clipcopy: platform ($nu.os-info.name) not supported" }
    }
  }
}

def --env mkt [] {
  cd ((^mktemp -d) | str trim)
}

def --wrapped pi [--version: string = "0.75.5", ...args] {
  let version = ($version | str trim --left --char "v")
  ^bunx $"@earendil-works/pi-coding-agent@v($version)" ...$args
}

def --wrapped cfg [...args] {
  ^git $"--git-dir=($env.HOME | path join '.cfg')" $"--work-tree=($env.HOME)" ...$args
}

def gitclean [] {
  ^git branch --merged
  | lines
  | each {|line| $line | str trim }
  | where {|branch| $branch != "" and not ($branch | str starts-with "*") and $branch != "master" }
  | each {|branch| ^git branch -d $branch }
}

def --wrapped gf [...args] { forgit ...$args }
def --wrapped ga [...args] { forgit add ...$args }
def --wrapped gd [...args] { forgit diff ...$args }
def --wrapped glo [...args] { forgit log ...$args }
def --wrapped gi [...args] { forgit ignore ...$args }
def --wrapped grh [...args] { forgit reset_head ...$args }
def --wrapped gcf [...args] { forgit checkout_file ...$args }
def --wrapped gcb [...args] { forgit checkout_branch ...$args }
def --wrapped gct [...args] { forgit checkout_tag ...$args }
def --wrapped gco [...args] { forgit checkout_commit ...$args }
def --wrapped grc [...args] { forgit revert_commit ...$args }
def --wrapped gclean [...args] { forgit clean ...$args }
def --wrapped gss [...args] { forgit stash_show ...$args }
def --wrapped gcp [...args] { forgit cherry_pick ...$args }
def --wrapped grb [...args] { forgit rebase ...$args }
def --wrapped gfu [...args] { forgit fixup ...$args }
