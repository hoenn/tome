# `tome`
A simple wrapper to make terminal note taking a reflex.

## Context
I've used the following bash functions in my source file for years:
```
# notes organized by date
labnotes() {
    vim "$HOME/.labnotes/$(gdate --date="$*" +%b-%d-%Y).lab.md"
}

# one off notes
notes() {
    vim "$HOME/.notes/$*.md"
}
```

These commands are perfectly servicable for my use-case and give me the features I care about most:
- Use my existing editor without any additional complexity (eg. a plugin)
- All my notes in one place and in one format
- Solve for date driven note taking, something I did in a journal previously. `labnotes today` always opens today's notes
- Organization light, not overburdened with planning a folder structure. Like a paper journal, I'll know where I've left things
- Highly compatible with existing CLI tooling, they're just markdown files of course.

If I was to extend the functionality of this super simple approach, this are the bits of functionality I'd want the most:
- Natively works with git but doesn't offer any shortcuts to a simple commit-push loop
- Lacks tab completion for `notes foo`
- Doesn't provide or account for any sort of simple templates, even for basic frontmatter
- Solves lightweight directory use (`notes foo/bar` -> `vim ./notes/foo/bar.md`) but doesn't create new directories.
- `labnotes` scales poorly in a single directory, having `./notes/YEAR/MONTH/foo` would help here.
- Showing recently edited notes would be really handy.
