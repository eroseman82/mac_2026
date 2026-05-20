# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Core/projects/python/garage/bin:$PATH"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# # Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

export EDITOR=nvim
export VISUAL=nvim
# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# YAZI 
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# ECHOS
# NOTE: removed `echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc` —
# it was appending itself on every shell startup, bloating this file.

# echo "🚀 LAST THOUGHT: $(cat ~/recover.md | grep '🚀' | tail -1)"
# echo "🔄 To reconstruct flow, type: recover"
# echo "Print Alias = showalias"
[ -f "$HOME/dotfiles/eric.md" ] && cat "$HOME/dotfiles/eric.md"
# For a full list of active aliases, run `alias`.
#
# Example aliases

# SUPABASE
alias supa='psql "postgresql://postgres.qbclaqbqizitxhdhykdr:qHGCXuHLtQv8MESH@aws-0-us-east-1.pooler.supabase.com:6543/postgres"'
# SSH 

# RASP PI 
alias pie='ssh eric@Raspy.local'
alias pifi='ssh eric@Raspy'
# HOSTINGER
#
alias eric='ssh hostinger'
alias hosty='ssh root@31.97.218.42'
# alias push='scp -r ~/.config/nvim eric@31.97.218.42:~/.config/'
# push () {
#   scp -r "$1" hostinger:mac/
# }
# PUSH HOSTINGER
push () {
  # Usage: push <file-or-dir>   (always lands in ~/mac/ on hostinger)
  if [[ -z "$1" ]]; then
    echo "Usage: push <file-or-dir>"
    return 2
  fi

  # Ensure destination exists
  ssh hostinger 'mkdir -p ~/mac' || return 1

  # rsync: -a archive, -v verbose, -z compress, --progress show progress
  rsync -avz --progress "$1" hostinger:~/mac/
}
pull () {
  # Pull everything from hostinger:~/mac/pull/ to local ~

  rsync -avz --progress hostinger:~/mac/pull/ ~/
}

# GIT Dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# DOCKER
alias dockerls='docker ps -a --format "table {{.Names}}\t{{.Image}}"'

#Gopass
alias goclose='gpgconf --kill gpg-agent'
alias clip="gopass show -c "
alias gp="gopass generate"

#VIM COMMANDLINE
bindkey -v
  # Cursor shape changes between modes (if your terminal supports it)
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $KEYMAP == viopp ]]; then
    echo -ne '\e[1 q'   # block cursor
  else
    echo -ne '\e[5 q'   # beam cursor
  fi
}
zle -N zle-keymap-select


#PYTHON
alias ur='uv run'
alias nvs='nvim $(fzf -m --preview="bat --color=always {}")'
# alias create='/Users/er/workspace/Scripts/python_creator.sh'
alias create='/Users/er/bin/python_creator.sh'
# alias rm='uv run main.py'
alias host='python3 -m http.server 8000'

#GIT
alias commit='git remote add origin ' 
## crete repo and push from cli 
gnew() {
  if [ -z "$1" ]; then
    echo "Usage: gnew <repo-name>"
    return 1
  fi

  gh repo create "$1" --private --source=. --push
}
#SCRIPTS
# echo 'alias iv="$HOME/Infoverse/Scripts/iv.sh"' >> ~/.zshrc
# echo 'alias iv="bash \"$HOME/bin/iv.sh""' >> ~/.zshrc


# Add these to your ~/.zshrc
# alias tree="cbonsai -l -i"
alias matrix="cmatrix" # MATRIX THEME
alias e="exit"
alias ncon="cd ~/.config/nvim"
alias tcon="cd ~/.config/tmux"
alias tm="tmux new -s workspace"
alias ec="./edit-config.sh"
alias showalias="grep '^alias ' ~/.zshrc"
alias zc="nvim ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias codexupdate="npm i -g @openai/codex@latest"
# alias ls="eza -T -L1 --group-directories-first"
alias ls="eza -T -L1 --group-directories-first --sort=extension"
alias v="nvim"
alias src="source ~/.zshrc"
alias c="z && clear"

# GOPASS FUNCTION
gkey() {
  local fullpath="$1"
  local rawname=$(basename "$fullpath")
  local varname=$(echo "$rawname" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
  export "${varname}=$(gopass show "$fullpath" | grep 'key:' | cut -d' ' -f2)"
  echo "Exported \$$varname"
}


# DB SCRIPT TASKS
addtask() {
  echo -n "📝 Task Description: "
  read description

  echo -n "🔥 Priority (low / med / high): "
  read priority

  echo -n "📌 Status (open / in_progress / done): "
  read task_status

  echo -n "🏷️ Tags (comma separated): "
  read tags

  tags_array="NULL"
  [[ -n "$tags" ]] && tags_array="'{\"${tags//,/\",\"}\"}'"

  psql -d eric -c \
    "INSERT INTO tasks (description, priority, tags, status, source)
     VALUES ('$description', '${priority:-medium}', $tags_array, '${task_status:-open}', 'cli');"
}


. "$HOME/.local/bin/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/er/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

export PATH="$HOME/Library/Python/3.12/bin:$PATH"

export YAZI_NO_TRUSTED_TERMINAL=1

eval "$(zoxide init zsh)"
alias iv="bash \"$HOME/bin/iv.sh\""

goo() {
    local base="$HOME/.dev" n=1
    mkdir -p "$base"
    while [ -e "$base/session$n" ]; do n=$((n + 1)); done
    local dir="$base/session$n"
    mkdir "$dir"
    cd "$dir"
}

# fnm (Node version manager) — auto-switches Node per project via .nvmrc
eval "$(fnm env --use-on-cd --shell zsh)"

# react-dev — launch any React/Next/Vite/CRA project on a chosen port
react-dev() {
  local port="${1:-3000}"
  local dir="${2:-$PWD}"
  cd "$dir" || return 1

  [ -f .nvmrc ] || echo "22" > .nvmrc
  eval "$(fnm env --shell zsh)" && fnm use || return 1
  [ -d node_modules ] || npm install || return 1

  local pid
  pid=$(lsof -ti tcp:"$port" 2>/dev/null)
  if [ -n "$pid" ]; then
    echo "Port $port held by PID $pid ($(ps -p "$pid" -o comm=))."
    read -q "?Kill it? [y/N] " || { echo; return 1; }
    echo; kill "$pid" && sleep 1
  fi

  if   grep -q '"next"'        package.json; then npm run dev -- -p "$port"
  elif grep -q '"vite"'        package.json; then npm run dev -- --port "$port"
  elif grep -q 'react-scripts' package.json; then PORT="$port" npm start
  else npm run dev
  fi
}
alias rd='react-dev'
