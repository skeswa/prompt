# prompt

A fast, simple [bash][bash] prompt.

![prompt screenshot][screenshot]

[screenshot]: screenshot.gif

## Installation
```bash
$ cd $WHERE_YOU_KEEP_GITHUB_REPOS
$ git clone https://github.com/skeswa/prompt
$ cd prompt
$ make install
$ . ~/.bashrc
```

### Assumptions
- We assume that you have `bash` installed at version `3.0.0` or higher
- We assume that you have `git` installed at version `2.0.0` or higher
- We assume that your terminal supports 256 colors
- We assume that your terminal color scheme has a dark(ish) background

## How to update
```bash
$ cd $WHERE_YOU_KEEP_GITHUB_REPOS/prompt
$ git pull
$ . ~/.bashrc
```

## Configuration
### Colors
Colors can be customized by editing the following environment variables:

- `PROMPT_PWD_COLOR` - Color for the current working directory (e.g. `~/a/b/c`), defaults to `38;5;43`
- `PROMPT_GIT_COLOR` - Color for the current git branch/ref (e.g. `:master`), defaults to `38;5;105`
- `PROMPT_USERHOST_COLOR` - Color for the current user session info (e.g. `corey@desktop`), defaults to `38;5;39`
- `PROMPT_DOLLAR_COLOR` - Color for the dollar sign, defaults to `38;5;255`
- `PROMPT_ERROR_COLOR` - Color for the dollar sign when the previous command failed, defaults to `38;5;204`

To come up with your own colors, take a look at the reference graphic below from [wikipedia][wiki-colors]:

[wiki-colors]: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

![color table][colors]

[colors]: colors.png

### Custom hostname
You can override the host name of your prompt (the `desktop` part of `corey@desktop`) by setting the `PROMPT_HOST_NAME` environment variable. For example, if your desired prompt is `corey@inthehouse`, then you might stick this in your `~/.bashrc` before the `. ~/.prompt/prompt.bash`:
```bash
export PROMPT_HOST_NAME='inthehouse'
```

## How does it work?
[bash][bash] provides a special set of [variables for your prompts][ps-vars]. `PS1` is the one used by default. The install script adds a command to `~/.bashrc`, a file that is run every time a new terminal opens. Inside of the new command, we run our script and set your `PS1` which runs some `git` commands to determine its current state and outputs them as a string.

[bash]: https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29
[ps-vars]: http://www.gnu.org/software/bash/manual/bashref.html#index-PS1

## Support
Linux and Mac OSX are supported platforms.

Windows is supported to the best of my abilities. However, there have been [font issues][putty-issue] with using [PuTTY][].

[PuTTY]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
[putty-issue]: https://github.com/twolfson/sexy-bash-prompt/issues/7

## Uninstallation
To uninstall `prompt`, perform the following steps:

- Remove `. ~/.prompt/prompt.bash` and `. ~/.prompt/git-completion.bash` from `~/.bashrc`
- Delete `~/.prompt` (e.g. `rm ~/.prompt`)
- Remove the repository folder from which `prompt` was originally installed
- During installation, we may have added a `. ~/.bashrc` invocation to `~/.bash_profile`, `~/.bash_login`, or `~/.profile`
    - Feel free to remove this if it's no longer necessary

## License
Copyright (c) 2017 Sandile Keswa

Licensed under the MIT license.
