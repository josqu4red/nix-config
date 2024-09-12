# List direcory contents
alias l='ls -lh'
alias la='ls -Alh'
alias rr='rm -rf'
alias sudo='sudo '
alias diff='colordiff -bur'
alias dd='dd status=progress'
alias md='mkdir -p'
alias rd=rmdir

export GREP_COLOR='mt=1;32'
alias grep='grep --color=auto'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias j='sudo journalctl'
alias ju='journalctl --user'
alias s='sudo systemctl'
alias su='systemctl --user'
