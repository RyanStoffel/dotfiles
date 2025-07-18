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
alias project-create='sf project generate'
alias project-test='sf apex run test'
alias convert='sf project convert source'
alias deploy-metadata='sf deploy metadata'

# Apex development
alias apex-log='sf apex get log'

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

# =============================================================================
# Wrapper Functions (suppress warnings and provide clean output)
# =============================================================================

# Lightning Web Component creation
function create-lwc() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-lwc <component-name>"
        return 1
    fi
    
    echo "🚀 Creating LWC: $1..."
    SF_AUTOUPDATE_DISABLE=true sf lightning generate component --type lwc --output-dir force-app/main/default/lwc --name "$1" 2>/dev/null | grep -E "(create|identical|target dir)"
    echo "✅ LWC '$1' completed!"
}

# Apex class creation
function create-class() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-class <class-name>"
        return 1
    fi
    
    echo "🚀 Creating Apex class: $1..."
    SF_AUTOUPDATE_DISABLE=true sf apex generate class --name "$1" 2>/dev/null | grep -E "(create|identical|target dir)"
    echo "✅ Apex class '$1' completed!"
}

# Apex trigger creation
function create-trigger() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-trigger <trigger-name>"
        return 1
    fi
    
    echo "🚀 Creating Apex trigger: $1..."
    SF_AUTOUPDATE_DISABLE=true sf apex generate trigger --name "$1" 2>/dev/null | grep -E "(create|identical|target dir)"
    echo "✅ Apex trigger '$1' completed!"
}

# Deploy function
function deploy() {
    echo "🚀 Deploying to org..."
    SF_AUTOUPDATE_DISABLE=true sf project deploy start 2>/dev/null | grep -v "Warning\|Error Plugin"
    echo "✅ Deploy completed!"
}

# Retrieve function  
function retrieve() {
    echo "🚀 Retrieving from org..."
    SF_AUTOUPDATE_DISABLE=true sf project retrieve start 2>/dev/null | grep -v "Warning\|Error Plugin"
    echo "✅ Retrieve completed!"
}

# =============================================================================
# Enhanced Salesforce Development Functions
# =============================================================================

function sf-scratch() {
    if [ $# -eq 0 ]; then
        echo "Usage: sf-scratch <org-name> [duration-days]"
        return 1
    fi
    
    local org_name="$1"
    local duration="${2:-7}"
    
    echo "🚀 Creating scratch org: $org_name (${duration} days)..."
    SF_AUTOUPDATE_DISABLE=true sf org create scratch --definition-file config/project-scratch-def.json \
        --alias "$org_name" \
        --duration-days "$duration" \
        --set-default 2>/dev/null | grep -v "Warning\|Error Plugin"
    echo "✅ Scratch org '$org_name' created!"
}

function sf-push() {
    echo "🚀 Pushing source to scratch org..."
    SF_AUTOUPDATE_DISABLE=true sf project deploy start --source-dir force-app/main/default 2>/dev/null | grep -v "Warning\|Error Plugin"
    echo "✅ Source push completed!"
}

function sf-pull() {
    echo "🚀 Pulling source from scratch org..."
    SF_AUTOUPDATE_DISABLE=true sf project retrieve start --source-dir force-app/main/default 2>/dev/null | grep -v "Warning\|Error Plugin"
    echo "✅ Source pull completed!"
}

function apex-execute() {
    if [ $# -eq 0 ]; then
        echo "Usage: apex-execute <apex-code>"
        return 1
    fi
    
    echo "🚀 Executing Apex code..."
    echo "$1" | SF_AUTOUPDATE_DISABLE=true sf apex run --target-org $(sf config get target-org --json | jq -r '.result[0].value') 2>/dev/null
    echo "✅ Apex execution completed!"
}

# Enhanced LWC creation with directory check
function create-lwc-enhanced() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-lwc-enhanced <component-name>"
        return 1
    fi
    
    # Ensure we're in a Salesforce project
    if [[ ! -f "sfdx-project.json" ]]; then
        echo "❌ Not in a Salesforce project directory"
        return 1
    fi
    
    echo "🚀 Creating enhanced LWC: $1..."
    SF_AUTOUPDATE_DISABLE=true sf lightning generate component --type lwc --name "$1" --output-dir force-app/main/default/lwc 2>/dev/null | grep -E "(create|identical|target dir)"
    echo "✅ Enhanced LWC '$1' created successfully!"
}

# Aura component creation
function create-aura() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-aura <component-name>"
        return 1
    fi
    
    echo "🚀 Creating Aura component: $1..."
    SF_AUTOUPDATE_DISABLE=true sf lightning generate component --type aura --name "$1" 2>/dev/null | grep -E "(create|identical|target dir)"
    echo "✅ Aura component '$1' completed!"
}

# Quick navigation to common Salesforce directories
function salesforce-nav() {
    case "$1" in
        "classes")
            cd force-app/main/default/classes
            echo "📁 Navigated to Apex classes"
            ;;
        "triggers")
            cd force-app/main/default/triggers
            echo "📁 Navigated to Apex triggers"
            ;;
        "lwc")
            cd force-app/main/default/lwc
            echo "📁 Navigated to Lightning Web Components"
            ;;
        "aura")
            cd force-app/main/default/aura
            echo "📁 Navigated to Aura components"
            ;;
        "objects")
            cd force-app/main/default/objects
            echo "📁 Navigated to Custom objects"
            ;;
        "flows")
            cd force-app/main/default/flows
            echo "📁 Navigated to Flows"
            ;;
        "config")
            cd config
            echo "📁 Navigated to Config directory"
            ;;
        "list")
            echo "Available navigation options:"
            echo "  classes  - Apex classes directory"
            echo "  triggers - Apex triggers directory"
            echo "  lwc      - Lightning Web Components directory"
            echo "  aura     - Aura components directory"
            echo "  objects  - Custom objects directory"
            echo "  flows    - Flows directory"
            echo "  config   - Config directory"
            ;;
        *)
            echo "Usage: sfnav {classes|triggers|lwc|aura|objects|flows|config|list}"
            ;;
    esac
}

alias sfnav='salesforce-nav'

# Org management functions
function sf-org() {
    case "$1" in
        "list")
            SF_AUTOUPDATE_DISABLE=true sf org list 2>/dev/null | grep -v "Warning\|Error Plugin"
            ;;
        "open")
            echo "🚀 Opening org: ${2:-default}"
            SF_AUTOUPDATE_DISABLE=true sf org open ${2:-} 2>/dev/null
            ;;
        "info")
            SF_AUTOUPDATE_DISABLE=true sf org display ${2:-} 2>/dev/null | grep -v "Warning\|Error Plugin"
            ;;
        "default")
            if [ $# -lt 2 ]; then
                echo "Usage: sf-org default <org-alias>"
                return 1
            fi
            echo "🚀 Setting default org: $2"
            SF_AUTOUPDATE_DISABLE=true sf config set target-org "$2" 2>/dev/null
            echo "✅ Default org set to '$2'"
            ;;
        *)
            echo "Usage: sf-org {list|open|info|default} [org-alias]"
            echo "  list     - List all orgs"
            echo "  open     - Open org in browser"
            echo "  info     - Display org information"
            echo "  default  - Set default org"
            ;;
    esac
}

# Test runner function
function apex-test() {
    if [ $# -eq 0 ]; then
        echo "🚀 Running all Apex tests..."
        SF_AUTOUPDATE_DISABLE=true sf apex run test --wait 10 --result-format human --output-dir ./test-results --coverage-formatters html 2>/dev/null | grep -v "Warning\|Error Plugin"
    else
        echo "🚀 Running test class: $1"
        SF_AUTOUPDATE_DISABLE=true sf apex run test --class-names "$1" --wait 10 --result-format human 2>/dev/null | grep -v "Warning\|Error Plugin"
    fi
    echo "✅ Test execution completed!"
}

# Quick file search functions
function find-apex() {
    if [ $# -eq 0 ]; then
        echo "Usage: find-apex <search-term>"
        return 1
    fi
    
    echo "🔍 Searching for Apex files containing: $1"
    find force-app/main/default/classes -name "*.cls" -exec grep -l "$1" {} \;
}

function find-lwc() {
    if [ $# -eq 0 ]; then
        echo "Usage: find-lwc <search-term>"
        return 1
    fi
    
    echo "🔍 Searching for LWC files containing: $1"
    find force-app/main/default/lwc -name "*.js" -o -name "*.html" -exec grep -l "$1" {} \;
}

# =============================================================================
# Salesforce CLI Environment (warnings suppressed)
# =============================================================================
if command -v sf >/dev/null 2>&1; then
    export SF_AUTOUPDATE_DISABLE=true
fi
