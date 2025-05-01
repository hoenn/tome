_tome_completion() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  local root="${TOME_DIR:-$HOME/.tome}"

  local commands="note date recent templates n d r"

  # Subcommand completion
  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    return 0
  fi

  # Note filename completion
  if [[ "$prev" == "note" || "$prev" == "n" ]]; then
    if [[ -d "$root" ]]; then
      local files
      files=$(find "$root" -type f -name "*.md" 2>/dev/null | sed "s|$root/||; s|\.md$||")
      COMPREPLY=( $(compgen -W "$files" -- "$cur") )
    fi
    return 0
  fi

  local templates_dir="$root/.templates"
  local templates=""
  if [[ -d "$templates_dir" ]]; then
    templates=$(find "$templates_dir" -type f -name "*.md" 2>/dev/null | sed 's|.*/||; s|\.md$||')
  fi

  # --template VALUE or --t VALUE
  if [[ "$prev" == "--template" || "$prev" == "-t" ]]; then
    COMPREPLY=( $(compgen -W "$templates" -- "$cur") )
    return 0
  fi
}

complete -F _tome_completion tome

