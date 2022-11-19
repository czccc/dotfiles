
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
export DOTFILES_DIR=${HOME}/dotfiles

# source "${ZDOTDIR:-$HOME}/.zprofile"
if [[ -s "${ZDOTDIR}/.zprofile" ]]; then
  source "${ZDOTDIR}/.zprofile"
fi

# source "${ZDOTDIR:-$HOME}/.zshenv"
if [[ -s "${ZDOTDIR}/.zshenv" ]]; then
  source "${ZDOTDIR}/.zshenv"
fi

# Source Prezto.
if [[ ${ZDOTDIR} != ${HOME} ]] && [[ -s "${ZDOTDIR}/.zshrc" ]]; then
  source "${ZDOTDIR}/.zshrc"
elif [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
else
  echo "Zsh config file not found!\n"
fi

