#! /bin/bash

# This value is used to hold the return value of the prompt sub-functions.
__prompt_retval=""

# Create some color constants to make the prompt a little more readable.
__prompt_color_prefix="\[\e["
__prompt_256_prefix="38;5;"
__prompt_color_suffix="m\]"
__prompt_no_color="\[\e[0m\]"

# Set the path color. Defaults to green. It can be overwritten by
# `PROMPT_PWD_COLOR`.
__prompt_pwd_color="${__prompt_color_prefix}${__prompt_256_prefix}43${__prompt_color_suffix}"
if ! [[ -z $PROMPT_PWD_COLOR ]]; then
  __prompt_pwd_color="${__prompt_color_prefix}${PROMPT_PWD_COLOR}${__prompt_color_suffix}"
fi

# Set the git color. Defaults to purple. It can be overwritten by
# `PROMPT_GIT_COLOR`.
__prompt_git_color="${__prompt_color_prefix}${__prompt_256_prefix}105${__prompt_color_suffix}"
if ! [[ -z $PROMPT_GIT_COLOR ]]; then
  __prompt_git_color="${__prompt_color_prefix}${PROMPT_GIT_COLOR}${__prompt_color_suffix}"
fi

# Set the user-host color. Defaults to blue. It can be overwritten by
# `PROMPT_USERHOST_COLOR`.
__prompt_userhost_color="${__prompt_color_prefix}${__prompt_256_prefix}39${__prompt_color_suffix}"
if ! [[ -z $PROMPT_USERHOST_COLOR ]]; then
  __prompt_userhost_color="${__prompt_color_prefix}${PROMPT_USERHOST_COLOR}${__prompt_color_suffix}"
fi

# Set the error color. Defaults to red. It can be overwritten by
# `PROMPT_ERROR_COLOR`.
__prompt_error_color="${__prompt_color_prefix}${__prompt_256_prefix}204${__prompt_color_suffix}"
if ! [[ -z $PROMPT_ERROR_COLOR ]]; then
  __prompt_error_color="${__prompt_color_prefix}${PROMPT_ERROR_COLOR}${__prompt_color_suffix}"
fi

# Set the dollar color. Defaults to white. It can be overwritten by
# `PROMPT_DOLLAR_COLOR`.
__prompt_dollar_color="${__prompt_color_prefix}${__prompt_256_prefix}255${__prompt_color_suffix}"
if ! [[ -z $PROMPT_DOLLAR_COLOR ]]; then
  __prompt_dollar_color="${__prompt_color_prefix}${PROMPT_DOLLAR_COLOR}${__prompt_color_suffix}"
fi

# Gets the current working directory path, but shortens the directories in the
# middle of long paths to just their respective first letters.
function __prompt_get_short_pwd {
  # Break down the local variables.
  local dir=`dirs +0`
  local dir_parts=(${dir//// })
  local number_of_parts=${#dir_parts[@]}

  # If there are less than 6 path parts, then do no shortening.
  if [[ "$number_of_parts" -gt "5" ]]; then
    # Leave the last 2 part parts alone.
    local last_index="$(( $number_of_parts - 3 ))"
    local short_pwd=""

    for i in "${!dir_parts[@]}"; do
      # Append a '/' before we do anything (provided this isn't the first part).
      if [[ "$i" -gt "0" ]]; then
        short_pwd+='/'
      fi

      # Don't shorten the first/last few arguments - leave them as-is.
      if [[ "$i" -lt "3" ]] || [[ "$i" -gt "$last_index" ]]; then
        short_pwd+="${dir_parts[i]}"
      else
        # This means that this path part is in the middle of the path. Our logic
        # dictates that we shorten parts in the middle like this.
        short_pwd+="${dir_parts[i]:0:1}"
      fi
    done

    # Return the resulting short pwd.
    __prompt_retval="$short_pwd"
  else
    # We didn't change anything, so return the original pwd.
    __prompt_retval="$dir"
  fi
}

# Returns the user@host. The host is overriden by `PROMPT_HOST_NAME`.
function __prompt_get_host() {
  # Check to see if we already have the host name cached.
  if [[ -z $PROMPT_HOST_NAME ]]; then
    # We do not have the friendly host name cached, so use use '\h'.
    __prompt_retval='\u@\h'
  else
    # We have the host name cached! Dope! Let's use it.
    __prompt_retval="\u@$PROMPT_HOST_NAME"
  fi
}

# Returns the git branch (if there is one), or returns empty.
function __prompt_get_git_stuff() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi

    # Return the resulting git branch/ref.
    __prompt_retval=":$branch"
  else
    # Return empty if there is no git stuff.
    __prompt_retval=''
  fi
}

# This function creates prompt.
function __prompt_command() {
  # Make the dollar red if the last command exited with error.
  local last_command_retval="$?"
  local dollar_color="$__prompt_dollar_color"
  if [ $last_command_retval -ne 0 ]; then
    dollar_color="$__prompt_error_color"
  fi

  # Calculate prompt parts.
  __prompt_get_short_pwd
  local short_pwd="${__prompt_pwd_color}${__prompt_retval}"
  __prompt_get_host
  local host="${__prompt_userhost_color}${__prompt_retval}"
  __prompt_get_git_stuff
  local git_stuff="${__prompt_git_color}${__prompt_retval}"
  local dollar="${dollar_color}$"

  # Set the PS1 to the new prompt.
  PS1="${short_pwd}${git_stuff} ${host} ${dollar}${__prompt_no_color} "
}

# Tell bash about the function above.
export PROMPT_COMMAND=__prompt_command
