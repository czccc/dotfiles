
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
export DOTFILES_DIR=${HOME}/dotfiles
# source "${ZDOTDIR:-$HOME}/.zshenv"
if [[ -s "${ZDOTDIR}/.zshenv" ]]; then
  source "${ZDOTDIR}/.zshenv"
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
if [[ ${ZDOTDIR} != ${HOME} ]] && [[ -s "${ZDOTDIR}/.zshrc" ]]; then
  source "${ZDOTDIR}/.zshrc"
elif [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

