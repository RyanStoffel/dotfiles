# Quick directory navigation
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Git functions
function gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

function gbranch() {
    if [ $# -eq 0 ]; then
        git branch -a
    else
        git checkout -b "$1"
    fi
}

# Development functions
function dev() {
    if [ -d "$DEV_HOME/$1" ]; then
        cd "$DEV_HOME/$1"
    else
        echo "Project $1 not found in $DEV_HOME"
    fi
}

# Salesforce Development Functions
function sf-org() {
    case "$1" in
        "list")
            sf org list
            ;;
        "open")
            sf org open ${2:-}
            ;;
        "info")
            sf org display ${2:-}
            ;;
        *)
            echo "Usage: sf-org {list|open|info} [org-alias]"
            ;;
    esac
}

# Quick file search
function ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

# Quick process search
function psg() {
    ps aux | grep -v grep | grep "$1"
}

# Extract function for various archive types
function extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Load custom functions from additional files
if [ -d "$ZDOTDIR/functions" ]; then
    for func in "$ZDOTDIR/functions"/*.zsh; do
        [ -r "$func" ] && source "$func"
    done
fi
