# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle ':zim' disable-version-check yes
zstyle ':zim:input' double-dot-expand yes
zstyle ':zim:git' aliases-prefix 'g'
zstyle ':zim:zmodule' use 'degit'

ZIM_HOME=${XDG_CACHE_HOME:-$HOME/.cache}/zim
DOTFILES_DIR=${HOME}/dotfiles

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  # Using dotfiles dir to get zimfw plugin manager if missing.
  mkdir -p ${ZIM_HOME} && ln -s ${DOTFILES_DIR}/config/zsh/zimfw.zsh ${ZIM_HOME}/zimfw.zsh
  # Using curl to download zimfw plugin manager if missing.
  # curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
  #     https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  # using wget to download zimfw plugin manager if missing.
  # mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
  #     https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


alias gcl='git clone --recurse-submodules'
