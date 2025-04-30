
# Bash completion for `tome`
_tome_completion() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local commands="note date recent list"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    return 0
  fi

  if [[ "$prev" == "note" ]]; then
    local root="${TOME_DIR:-$HOME/.tome}"
    if [[ -d "$root" ]]; then
      local files=$(find "$root" -type f -name "*.md" 2>/dev/null | sed "s|$root/||; s|\.md$||")
      COMPREPLY=( $(compgen -W "$files" -- "$cur") )
    fi
    return 0
  fi
}

complete -F _tome_completion tome

