PROMPT='%B%F{green}[%1~]%f%b%F{242}%#%f '

alias ..="cd ../"
alias ~="cd ~/"
alias cl="clear"
alias ls="eza"
alias la="eza -a"
alias l1="eza -1"
alias tree="eza -T"
alias nvsu="sudo -E nvim"
alias bat="bat --color=always --theme=ansi --style=-numbers,-header,+changes"
alias dcdu="docker compose down; docker compose up -d"
alias nixsysup="sudo nixos-rebuild switch --upgrade"
alias nixsysed="nvsu /etc/nixos/configuration.nix"
alias nixlsgens="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
alias nixusrup="nix profile upgrade nix/loganp --verbose"
alias lava="lavat -c black -k magenta -s 4"
alias fzf="fzf --style full --preview 'bat --color=always --theme=ansi --style=-numbers,-header,+changes {}'"
source <(fzf --zsh)
