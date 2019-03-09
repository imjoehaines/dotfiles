alias ls='ls -GFh'
alias grep='grep --color=auto'
alias reload='source ~/.bash_profile'

# use bat instead of cat, if it's available
if type bat > /dev/null; then
  alias cat='bat'
fi

# git
alias g='git'
alias ga="g a"                    # add
alias gaa="g a -A"                # add all
alias gb="g b"                    # branch
alias gc="g c"                    # commit
alias gcm="g cm"                  # commit with message
alias gco="g co"                  # checkout
alias gl='g l'                    # pretty log (20 commits)
alias glm='g lm'                  # pretty log (100 commits)
alias gla='g la'                  # pretty log (all commits)
alias glu='g lu'                  # pretty log (commits not pushed to develop)
alias glum='g lum'                # pretty log (commits not pushed to master)
alias glua='g lua'                # pretty log (all unpushed commits)
alias gll='g ll'                  # long log (5 commits)
alias glt='g lt'                  # pretty log (relative date - 20 commits)
alias gs='g s'                    # status
alias gd='g d'                    # diff (split)
alias gdi='g di'                  # diff (inline)
alias glb='g lb'                  # pretty branch list
alias gcleanup='git_cleanup'      # delete merged branches

# git ignore generator
function gi() {
  curl --progress-bar https://www.gitignore.io/api/"$(IFS=, ; echo "$*")"
}

function git_cleanup {
  git checkout master &> /dev/null

  branches="$(git branch --merged master | grep -vE '(master|develop)')"

  if [[ ! -z "$branches" ]]; then
    echo 'Deleting the following branches:'
    echo "$branches"
    echo
    read -p 'Are you sure? ' -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git branch --merged master | grep -vE '(master|develop)' | xargs -n 1 git branch -d
    fi
  else
    echo 'No branches to cleanup'
  fi

  git checkout - &> /dev/null
}

RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
WHITE="\033[0;37m"
RESET="\033[0m"

function git_colour {
    local git_status="$(git status 2> /dev/null)"

    if [[ ! $git_status =~ "working tree clean" ]]; then
        echo -e $RED
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
        echo -e $YELLOW
    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo -e $CYAN
    else
        echo -e $BLUE
    fi
}

function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"

    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo " $branch"
    elif [[ $git_status =~ $on_commit ]]; then
        local commit=${BASH_REMATCH[1]}
        echo " $commit"
    fi
}

PS1="\A \[$GREEN\]\W"     # basename of pwd
PS1+="\[\$(git_colour)\]" # colours git status
PS1+="\$(git_branch)"     # prints current branch
PS1+="\[$RESET\]\$ "      # '#' for root, else '$'
export PS1

export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# -F: quit if the contents fit the screen
# -R: colors
# -X: no clearing of the screen after quit
LESS=-FRX
export LESS

export EDITOR="vim"

if [ -f $(brew --prefix)/etc/profile.d/z.sh ]; then
  . `brew --prefix`/etc/profile.d/z.sh
fi

if [ -f /Users/joehaines/dotfiles/git-completion.bash ]; then
  source /Users/joehaines/dotfiles/git-completion.bash
fi
