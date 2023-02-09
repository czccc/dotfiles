#!/usr/bin/zsh
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
DOTFILES_DIR=${HOME}/dotfiles

if [[ ! -e ${ZDOTDIR}/.zprezto ]]; then
  echo "Init zsh config in ZDOTDIR=\"${ZDOTDIR}\""
  mkdir -p ${ZDOTDIR}
  ln -s ${DOTFILES_DIR}/config/zsh/prezto ${ZDOTDIR}/.zprezto
  if [[ -s ${HOME}/.zshrc ]]; then
    echo "Found old .zshrc! Move to .zshrc_bk"
    mv ${HOME}/.zshrc ${HOME}/.zshrc_bk
  fi
  cp ${DOTFILES_DIR}/config/zsh/.zshrc ${HOME}/.zshrc
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR}/.${rcfile:t}"
  done
fi


