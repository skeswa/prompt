#! /bin/bash

# This file is lovingly stolen from https://github.com/twolfson/sexy-bash-prompt.
# Much love Todd.

# Create helper to determine if our PS1 is installed
ps1_is_installed () {
  # If our prompt is being loaded, exit positively. Otherwise, negatively.
  [[ -n "$(bash --login -i -c 'type -t __prompt_get_git_stuff' | grep 'function')" ]]
}

# If the PS1 already contains our current prompt, leave
ps1_is_installed && exit 0

# Only continue if ~/.prompt exists
if [ ! -d "$HOME/.prompt" ]; then
  echo "FATAL: Directory ~/.prompt not found. Execute 'make install' in 'skeswa/prompt' and then try again." 1>&2
  exit 1
fi

# Add the prompt invocation to .bashrc
echo "# Adding 'skeswa/prompt' to ~/.bashrc"
echo "" >> ~/.bashrc
echo "# Use 'skeswa/prompt' which is symlinked to '~/.prompt'." >> ~/.bashrc
echo ". ~/.prompt/prompt.bash" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "# Add git completion to the prompt (comes from 'skeswa/prompt')." >> ~/.bashrc
echo ". ~/.prompt/git-completion.bash" >> ~/.bashrc

# Update the inputrc
if [ ! -e "$HOME/.inputrc" ]; then
  echo "# Symlinking the 'skeswa/prompt' .inputrc"
  ln -s "$HOME/.prompt/inputrc" "$HOME/.inputrc"
else
  echo "# Did not symlink the 'skeswa/prompt' .inputrc since one already exists"
fi

# If our prompt is being loaded, leave
ps1_is_installed && exit 0

# Find which exists .bash_profile, .bash_login, or .profile
# By default, .bash_profile is our profile script
if [[ -f ~/.bash_profile ]]; then
  profile_script_short="~/.bash_profile"
  profile_script_full=~/.bash_profile
elif [[ -f ~/.bash_login ]]; then
  profile_script_short="~/.bash_login"
  profile_script_full=~/.bash_login
elif [[ -f ~/.profile ]]; then
  profile_script_short="~/.profile"
  profile_script_full=~/.profile
else
  echo "FATAL: Profile script not found." 1>&2
  exit 1
fi

# If the current script does not have notes about .bashrc
# DEV: Introduced due to #24, a regression that prevented users from logging in
if ! grep .bashrc "$profile_script_full" &> /dev/null; then
  # Add a bash invocation to the profile script
  echo "# Adding ~/.bashrc triggers to $profile_script_short"
  echo "# Trigger ~/.bashrc commands" >> "$profile_script_full"
  echo ". ~/.bashrc" >> "$profile_script_full"

  # If our prompt is not being loaded, notify the user and leave angrily
  if ! ps1_is_installed; then
    echo "'skeswa/prompt' was added to ~/.bashrc and $profile_script_short but is not being picked up by bash." 1>&2
    exit 1
  fi
# Otherwise, notify the user about how to add it but do nothing
else
  echo "# We cannot confirm that 'skeswa/prompt' was installed properly" 1>&2
  echo "# Please open a new terminal window to confirm" 1>&2
  echo "" 1>&2
  echo "# If it was not, please run the following code:" 1>&2
  echo "echo \". ~/.bashrc\" >> \"$profile_script_full\"" 1>&2
  exit 1
fi
