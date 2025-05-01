_tome_completion() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local commands="note date recent n d r"

  # Complete main command
  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    return 0
  fi

  # Autocomplete filenames for `note` and `n`
  if [[ "$prev" == "note" || "$prev" == "n" ]]; then
    local root="${TOME_DIR:-$HOME/.tome}"
    if [[ -d "$root" ]]; then
      local files=$(find "$root" -type f -name "*.md" 2>/dev/null | sed "s|$root/||; s|\.md$||")
      COMPREPLY=( $(compgen -W "$files" -- "$cur") )
    fi
    return 0
  fi

  # Autocomplete --template and --t options
  for word in "${COMP_WORDS[@]}"; do
    if [[ "$word" == "note" || "$word" == "n" || "$word" == "date" || "$word" == "d" ]]; then
      local templates_dir="${TOME_DIR:-$HOME/.tome}/.templates"
      if [[ -d "$templates_dir" && "$cur" == --t=* ]]; then
        local t_input="${cur#--t=}"
        local templates=$(find "$templates_dir" -type f -name "*.md" 2>/dev/null | sed "s|$templates_dir/||; s|\.md$||")
        COMPREPLY=( $(compgen -W "$templates" -- "$t_input") )
        COMPREPLY=( "${COMPREPLY[@]/#/--t=}" )
        return 0
      fi
      if [[ "$cur" == --template=* ]]; then
        local t_input="${cur#--template=}"
        local templates=$(find "$templates_dir" -type f -name "*.md" 2>/dev/null | sed "s|$templates_dir/||; s|\.md$||")
        COMPREPLY=( $(compgen -W "$templates" -- "$t_input") )
        COMPREPLY=( "${COMPREPLY[@]/#/--template=}" )
        return 0
      fi
    fi
  done
}

complete -F _tome_completion tome

