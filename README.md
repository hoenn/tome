# `tome`
Magic terminal note taking and journaling.

## Installation

To see options before installing:
```
install.sh --help
```

One line install
```
git clone https://github.com/hoenn/tome.git && cd tome && ./install.sh
```

## Usage
Once installed you can run the following command to see which commands are available.
```
tome --help
```

`tome` only creates markdown files in the `$TOME_ROOT` directory, making it very friendly for use with `git`. This simplicity also makes `tome` work great with Obsidian. Make use of `tome templates` to create consistent note structures that support your vault's linking and tagging organization.

When using `tome date` you can use relative date expressions like in the following examples:
```
tome date today
tome date tomorrow
tome date yesterday
tome date last thursday
tome date next thursday
tome date 2 days
tome date next wednesday +1 week +1 day
tome date 1 day ago
```

`tome date` by default will look for the `$TOME_ROOT/.templates/date.md` template if it exists, make use of this for recurring journaling, daily logs, etc.


#### Mac users
This project uses `gdate` which you'll need to install with brew for `tome date today` to work.
```
brew install coreutils
```

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

I've decided to wrap it up and into a more featured but compact tool to share.
