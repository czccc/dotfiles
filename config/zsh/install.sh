
DOTFILES_DIR=${HOME}/dotfiles
if [[ -s ${HOME}/.zshrc ]]; then
  echo "Found old .zshrc! Move to .zshrc_bk"
  mv ${HOME}/.zshrc ${HOME}/.zshrc_bk
fi
cp ${DOTFILES_DIR}/config/zsh/.zshrc ${HOME}/.zshrc


