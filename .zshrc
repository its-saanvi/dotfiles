fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
alias "\\ls"="\\ls --color='auto'"
alias ls="lsd"
# alias btop="btop --utf-force"
eval "$(starship init zsh)"
