# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (could use normal escape sequences too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
  eval PR_USER='%{$PR_BOLD$PR_GREEN%}%n${PR_NO_COLOR}'
  eval PR_USER_OP='%{$PR_BOLD$PR_GREEN%}%#${PR_NO_COLOR}'
  local PR_PROMPT='➤ $PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  eval PR_HOST='${PR_YELLOW}$(hostname -s)${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='%{$PR_BOLD$PR_GREEN%}$(hostname -s)${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}Error: %?%{$PR_NO_COLOR%})"

local user_host='${PR_USER}@${PR_HOST}'

#local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'
local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'

local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'

time='%{$PR_GREEN%}%*%{$PR_NO_COLOR%}'

LD=${USER}@$(hostname -s)
L=${#LD}

PROMPT="%{$PR_BOLD$PR_YELLOW%}
╭─"'$(printf '─%.0s' {1..$((COLUMNS-6))})'"─┤
│ ${user_host} ${time} ${current_dir} ${git_branch} ${return_code}%{$PR_BOLD$PR_YELLOW%}
╰─$PR_PROMPT %f"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_BOLD$PR_YELLOW%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$PR_NO_COLOR%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$PR_BOLD$PR_YELLOW%}●"
