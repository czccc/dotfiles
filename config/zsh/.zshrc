export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# export TERM=xterm-256color

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
export DOTFILES_DIR=${HOME}/dotfiles
# source "$ZDOTDIR/.zshenv"
if [[ -s "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi

if [[ ! -e ${ZDOTDIR}/.zprezto ]]; then
  echo "Init zsh config in ZDOTDIR=\"${ZDOTDIR}\""
  mkdir -p ${ZDOTDIR} 
  ln -s ${DOTFILES_DIR}/config/zsh/prezto ${ZDOTDIR}/.zprezto
  # ln -s ${DOTFILES_DIR}/config/zsh/.zpreztorc ${ZDOTDIR}/.zpreztorc
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR}/.${rcfile:t}"
  done
fi

# Source Prezto.
if [[ -s "${ZDOTDIR}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR}/.zprezto/init.zsh"
fi

autoload -Uz promptinit
promptinit
prompt agnoster

alias ll='ls -alh'
alias l='ls -alh'

alias vim='nvim'
alias t='tmux new -As0'
alias tm='tmux'
alias nv='nvim'
# alias n='nvim'

alias lg='lazygit'
alias gb='git branch'
alias gcl='git clone --recurse-submodules'
alias gst='git status'
alias gS='git submodule'
alias gSI='git submodule update --init --recursive'

alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'

alias vz="vim ~/.zshrc && source ~/.zshrc"
alias vzp="vim ${ZDOTDIR}/.zpreztorc && source ~/.zshrc"
