# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
PRIMARY_COLOR="blue"
SECONDARY_COLOR="208" # orange

GIT_PRIMARY_COLOR="yellow"
VENV_PRIMARY_COLOR="magenta"

return_code() {
  local -a symbols
  # workaround https://github.com/ohmyzsh/ohmyzsh/issues/10966#issuecomment-1355355508
  local jobs_bg="%{%F{cyan}%}⚙"
  
  symbols+="%(?..%{%F{red}%}%? ✘)"
  symbols+="%1(j. $jobs_bg.)" 

  [[ -n "$symbols" ]] && echo -n "$symbols" 
}

local context="%B%(!.%{$fg[red]%}.%{%F{$SECONDARY_COLOR}%})%(!.%n💀%m.󰀵)%b%{%F{reset}%}"
local user_symbol='%(!.#.$)'
local current_dir="%B%{%F{$SECONDARY_COLOR}%}%~%b%{%F{reset}%}"

local vcs_branch='$(git_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'
local -a ahead behind
ahead=$(git log --oneline @{upstream}.. 2>/dev/null)
behind=$(git log --oneline ..@{upstream} 2>/dev/null)

local -a PL_BRANCH_CHAR
() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  PL_BRANCH_CHAR=$'\ue0a0'         # 
}

if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
  PL_BRANCH_CHAR=$'\u21c5'
elif [[ -n "$ahead" ]]; then
  PL_BRANCH_CHAR=$'\u21b1'
elif [[ -n "$behind" ]]; then
  PL_BRANCH_CHAR=$'\u21b0'
fi

PROMPT="%{$fg[$PRIMARY_COLOR]╭──(%}${context}%{$fg[$PRIMARY_COLOR])─[%}${current_dir}%{$fg[$PRIMARY_COLOR]]%}${vcs_branch}
╰─${venv_prompt}%B${user_symbol}%b%{$reset_color%} "
RPROMPT="%B$(return_code)%b%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{─$fg[$PRIMARY_COLOR][%}%{$fg[$GIT_PRIMARY_COLOR]%}$PL_BRANCH_CHAR"
ZSH_THEME_GIT_PROMPT_SUFFIX="] "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} 󱗾%{$fg[$PRIMARY_COLOR]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[$PRIMARY_COLOR]%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[white]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{[$fg[$VENV_PRIMARY_COLOR]%}"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$fg[$PRIMARY_COLOR]%}] "
ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
