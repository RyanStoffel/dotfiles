# =============================================================================
# Salesforce Development Configuration
# =============================================================================
# Specialized configuration for Salesforce development projects

# Salesforce CLI aliases
alias sf-login='sf org login web'
alias sf-logout='sf org logout'
alias sf-status='sf org list'
alias sf-info='sf org display'
alias sf-open='sf org open'

# SFDX project shortcuts
alias sfdx-create='sf project generate'
alias sfdx-deploy='sf project deploy start'
alias sfdx-retrieve='sf project retrieve start'
alias sfdx-test='sf apex run test'

# Apex development
alias apex-log='sf apex get log'
alias apex-class='sf apex generate class'
alias apex-trigger='sf apex generate trigger'

# Lightning development
alias lwc-create='sf lightning generate component'
alias aura-create='sf lightning generate app'

# Data management
alias sf-export='sf data export tree'
alias sf-import='sf data import tree'
alias sf-query='sf data query'

# Package development
alias pkg-create='sf package create'
alias pkg-version='sf package version create'
alias pkg-install='sf package install'

# Environment variables for Salesforce development
export SF_AUTOUPDATE_DISABLE=true
export SF_LOG_LEVEL=info

# Functions for Salesforce development
function sf-scratch() {
    if [ $# -eq 0 ]; then
        echo "Usage: sf-scratch <org-name> [duration-days]"
        return 1
    fi
    
    local org_name="$1"
    local duration="${2:-7}"
    
    sf org create scratch --definition-file config/project-scratch-def.json \
        --alias "$org_name" \
        --duration-days "$duration" \
        --set-default
}

function sf-push() {
    sf project deploy start --source-dir force-app/main/default
}

function sf-pull() {
    sf project retrieve start --source-dir force-app/main/default
}

function apex-execute() {
    if [ $# -eq 0 ]; then
        echo "Usage: apex-execute <apex-code>"
        return 1
    fi
    
    echo "$1" | sf apex run --target-org $(sf config get target-org --json | jq -r '.result[0].value')
}

# Quick navigation to common Salesforce directories
function salesforce-nav() {
    case "$1" in
        "classes")
            cd force-app/main/default/classes
            ;;
        "triggers")
            cd force-app/main/default/triggers
            ;;
        "lwc")
            cd force-app/main/default/lwc
            ;;
        "aura")
            cd force-app/main/default/aura
            ;;
        "objects")
            cd force-app/main/default/objects
            ;;
        "flows")
            cd force-app/main/default/flows
            ;;
        "config")
            cd config
            ;;
        *)
            echo "Available options: classes, triggers, lwc, aura, objects, flows, config"
            ;;
    esac
}

alias sfnav='salesforce-nav'

# Completion for Salesforce CLI
if command -v sf >/dev/null 2>&1; then
    # Enable SF CLI completion
    eval "$(sf autocomplete:script zsh)"
fi
