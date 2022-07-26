# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst
typeset -Ag FG BG

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

function collapsed_wd() {
  echo $(pwd | perl -pe "s|^$HOME|~|g; s|/([^/]{${ZSH_THEME_DIR_SLICE:=1}})[^/]*(?=/)|/\$1|g")
}

function spectrum_ls() {
  count=0
  for code in {000..015}; do
    ((count = count + 1))
    print -n -P -- "$BG[$code] %{$reset_color%}$FG[$code]$code$BG[$code] %{$reset_color%} "
    if [ $count -eq 8 ]; then echo; count=0; fi
  done
  echo
  for code in {016..255}; do
    ((count = count + 1))
    print -n -P -- "$BG[$code] %{$reset_color%}$FG[$code]$code$BG[$code] %{$reset_color%} "
    if [ $count -eq 6 ]; then echo; count=0; fi
  done
}

local user_color=$FG[040]; [ $UID -eq 0 ] && user_color=$FG[166]
PROMPT='$user_color%n@%m $FG[032]$(collapsed_wd) %{$reset_color%}%(!.#.$) '
PROMPT2='$FG[166]\> %{$reset_color%}'

local return_status="$FG[124]%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$(git_prompt_info) $(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" $FG[166]"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="$FG[040]+"
ZSH_THEME_GIT_PROMPT_MODIFIED="$FG[032]!"
ZSH_THEME_GIT_PROMPT_DELETED="$FG[166]-"
ZSH_THEME_GIT_PROMPT_RENAMED="$FG[129]>"
ZSH_THEME_GIT_PROMPT_UNMERGED="$FG[214]#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$FG[087]?"

ZSH_THEME_DIR_SLICE=3
