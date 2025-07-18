# =============================================================================
# Salesforce Development Configuration
# =============================================================================
# Specialized configuration for Salesforce development projects

# Salesforce CLI aliases (simple ones that don't need custom output)
alias sf-login='sf org login web'
alias sf-logout='sf org logout'
alias sf-status='sf org list'
alias sf-info='sf org display'
alias sf-open='sf org open'

# SFDX project shortcuts (simple aliases)
alias project-create='sf project generate'
alias project-test='sf apex run test'
alias convert='sf project convert source'
alias deploy-metadata='sf deploy metadata'

# Apex development (simple alias)
alias apex-log='sf apex get log'

# Data management (simple aliases)
alias sf-export='sf data export tree'
alias sf-import='sf data import tree'
alias sf-query='sf data query'

# Package development (simple aliases)
alias pkg-create='sf package create'
alias pkg-version='sf package version create'
alias pkg-install='sf package install'

# Environment variables for Salesforce development
export SF_AUTOUPDATE_DISABLE=true
export SF_LOG_LEVEL=info

# =============================================================================
# Silent Wrapper Functions (clean output, no warnings)
# =============================================================================

# Lightning Web Component creation
function create-lwc() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-lwc <component-name>"
        return 1
    fi
    
    echo "Creating LWC: $1..."
    
    # Run command completely silently, then check if files were created
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf lightning generate component --type lwc --output-dir force-app/main/default/lwc --name "$1" >/dev/null 2>&1
    
    # Check if the component was created successfully
    if [[ -d "force-app/main/default/lwc/$1" ]]; then
        echo "  Created component directory: force-app/main/default/lwc/$1"
        echo "  Files created:"
        ls -la "force-app/main/default/lwc/$1" | grep -E "\.(js|html|xml)$" | awk '{print "    " $9}'
        echo "LWC '$1' created successfully!"
    else
        echo "Failed to create LWC '$1'"
        return 1
    fi
}

# Apex class creation
function create-class() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-class <class-name>"
        return 1
    fi
    
    echo "Creating Apex class: $1..."
    
    # Run command silently
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf apex generate class --name "$1" >/dev/null 2>&1
    
    # Check if the class was created successfully
    if [[ -f "force-app/main/default/classes/$1.cls" ]]; then
        echo "  Created class file: force-app/main/default/classes/$1.cls"
        echo "  Created meta file: force-app/main/default/classes/$1.cls-meta.xml"
        echo "Apex class '$1' created successfully!"
    else
        echo "Failed to create Apex class '$1'"
        return 1
    fi
}

# Apex trigger creation
function create-trigger() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-trigger <trigger-name>"
        return 1
    fi
    
    echo "Creating Apex trigger: $1..."
    
    # Run command silently
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf apex generate trigger --name "$1" >/dev/null 2>&1
    
    # Check if the trigger was created successfully
    if [[ -f "force-app/main/default/triggers/$1.trigger" ]]; then
        echo "  Created trigger file: force-app/main/default/triggers/$1.trigger"
        echo "  Created meta file: force-app/main/default/triggers/$1.trigger-meta.xml"
        echo "Apex trigger '$1' created successfully!"
    else
        echo "Failed to create Apex trigger '$1'"
        return 1
    fi
}

# Aura component creation
function create-aura() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-aura <component-name>"
        return 1
    fi
    
    echo "Creating Aura component: $1..."
    
    # Run command silently
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf lightning generate component --type aura --name "$1" >/dev/null 2>&1
    
    # Check if the component was created successfully
    if [[ -d "force-app/main/default/aura/$1" ]]; then
        echo "  Created component directory: force-app/main/default/aura/$1"
        echo "  Files created:"
        ls -la "force-app/main/default/aura/$1" | grep -E "\.(cmp|css|js|svg)$" | awk '{print "    " $9}'
        echo "Aura component '$1' created successfully!"
    else
        echo "Failed to create Aura component '$1'"
        return 1
    fi
}

# Deploy function
function deploy() {
    echo "Deploying to org..."
    
    # Run deploy silently and capture result
    local temp_file=$(mktemp)
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf project deploy start >"$temp_file" 2>&1
    local deploy_result=$?
    
    # Check deployment result
    if [ $deploy_result -eq 0 ]; then
        echo "  Deployment initiated successfully"
        # Show relevant output without warnings
        grep -E "(Deployed|Job ID|Status)" "$temp_file" 2>/dev/null || echo "  Check org for deployment status"
        echo "Deploy completed successfully!"
    else
        echo "Deploy failed!"
        # Show errors but filter out warnings
        grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check deployment logs for details"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
}

# Retrieve function  
function retrieve() {
    echo "Retrieving from org..."
    
    # Run retrieve silently and capture result
    local temp_file=$(mktemp)
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf project retrieve start >"$temp_file" 2>&1
    local retrieve_result=$?
    
    # Check retrieve result
    if [ $retrieve_result -eq 0 ]; then
        echo "  Retrieve initiated successfully"
        # Show relevant output without warnings
        grep -E "(Retrieved|Job ID|Status)" "$temp_file" 2>/dev/null || echo "  Check for retrieved files"
        echo "Retrieve completed successfully!"
    else
        echo "Retrieve failed!"
        # Show errors but filter out warnings
        grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check retrieve logs for details"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
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
    
    echo "Creating scratch org: $org_name (${duration} days)..."
    
    # Run command silently
    local temp_file=$(mktemp)
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf org create scratch --definition-file config/project-scratch-def.json \
        --alias "$org_name" \
        --duration-days "$duration" \
        --set-default >"$temp_file" 2>&1
    local result=$?
    
    if [ $result -eq 0 ]; then
        echo "  Org alias: $org_name"
        echo "  Duration: ${duration} days"
        grep -E "(Org ID|Username)" "$temp_file" 2>/dev/null || echo "  Scratch org created successfully"
        echo "Scratch org '$org_name' created successfully!"
    else
        echo "Failed to create scratch org '$org_name'"
        grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check scratch org limits and definition file"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
}

function sf-push() {
    echo "Pushing source to scratch org..."
    
    local temp_file=$(mktemp)
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf project deploy start --source-dir force-app/main/default >"$temp_file" 2>&1
    local result=$?
    
    if [ $result -eq 0 ]; then
        echo "  Source pushed to scratch org"
        grep -E "(Deployed|Status)" "$temp_file" 2>/dev/null || echo "  Push completed"
        echo "Source push completed successfully!"
    else
        echo "Source push failed!"
        grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check push logs for details"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
}

function sf-pull() {
    echo "Pulling source from scratch org..."
    
    local temp_file=$(mktemp)
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf project retrieve start --source-dir force-app/main/default >"$temp_file" 2>&1
    local result=$?
    
    if [ $result -eq 0 ]; then
        echo "  Source pulled from scratch org"
        grep -E "(Retrieved|Status)" "$temp_file" 2>/dev/null || echo "  Pull completed"
        echo "Source pull completed successfully!"
    else
        echo "Source pull failed!"
        grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check pull logs for details"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
}

function apex-execute() {
    if [ $# -eq 0 ]; then
        echo "Usage: apex-execute <apex-code>"
        return 1
    fi
    
    echo "Executing Apex code..."
    
    local temp_file=$(mktemp)
    echo "$1" | SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf apex run >"$temp_file" 2>&1
    local result=$?
    
    if [ $result -eq 0 ]; then
        echo "  Apex code executed successfully"
        # Show execution result without warnings
        grep -v -E "(Warning|Error Plugin|module:)" "$temp_file" | head -20
        echo "Apex execution completed!"
    else
        echo "Apex execution failed!"
        grep -E "(ERROR|EXCEPTION)" "$temp_file" 2>/dev/null || echo "  Check Apex syntax and permissions"
        rm "$temp_file"
        return 1
    fi
    
    rm "$temp_file"
}

# Quick navigation to common Salesforce directories
function salesforce-nav() {
    case "$1" in
        "classes")
            cd force-app/main/default/classes
            echo "Navigated to Apex classes"
            ;;
        "triggers")
            cd force-app/main/default/triggers
            echo "Navigated to Apex triggers"
            ;;
        "lwc")
            cd force-app/main/default/lwc
            echo "Navigated to Lightning Web Components"
            ;;
        "aura")
            cd force-app/main/default/aura
            echo "Navigated to Aura components"
            ;;
        "objects")
            cd force-app/main/default/objects
            echo "Navigated to Custom objects"
            ;;
        "flows")
            cd force-app/main/default/flows
            echo "Navigated to Flows"
            ;;
        "config")
            cd config
            echo "Navigated to Config directory"
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
            echo "Listing orgs..."
            SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf org list 2>/dev/null | grep -v -E "(Warning|Error Plugin|module:)"
            ;;
        "open")
            echo "Opening org: ${2:-default}"
            SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf org open ${2:-} >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "Org opened in browser!"
            else
                echo "Failed to open org"
            fi
            ;;
        "info")
            echo "Getting org info..."
            SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf org display ${2:-} 2>/dev/null | grep -v -E "(Warning|Error Plugin|module:)"
            ;;
        "default")
            if [ $# -lt 2 ]; then
                echo "Usage: sf-org default <org-alias>"
                return 1
            fi
            echo "Setting default org: $2"
            SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf config set target-org "$2" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "Default org set to '$2'"
            else
                echo "Failed to set default org"
            fi
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
        echo "Running all Apex tests..."
        local temp_file=$(mktemp)
        SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf apex run test --wait 10 --result-format human --output-dir ./test-results --coverage-formatters html >"$temp_file" 2>&1
        local result=$?
        
        if [ $result -eq 0 ]; then
            echo "  All tests executed"
            grep -E "(PASS|FAIL|Test Results|Coverage)" "$temp_file" 2>/dev/null | head -20
            echo "Test execution completed!"
        else
            echo "Test execution failed!"
            grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check test logs for details"
        fi
        rm "$temp_file"
    else
        echo "Running test class: $1"
        local temp_file=$(mktemp)
        SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf apex run test --class-names "$1" --wait 10 --result-format human >"$temp_file" 2>&1
        local result=$?
        
        if [ $result -eq 0 ]; then
            echo "  Test class '$1' executed"
            grep -E "(PASS|FAIL|Test Results)" "$temp_file" 2>/dev/null | head -10
            echo "Test execution completed!"
        else
            echo "Test execution failed!"
            grep -E "(ERROR|FAILED)" "$temp_file" 2>/dev/null || echo "  Check test class name and syntax"
        fi
        rm "$temp_file"
    fi
}

# Quick file search functions
function find-apex() {
    if [ $# -eq 0 ]; then
        echo "Usage: find-apex <search-term>"
        return 1
    fi
    
    echo "Searching for Apex files containing: $1"
    local results=$(find force-app/main/default/classes -name "*.cls" -exec grep -l "$1" {} \; 2>/dev/null)
    
    if [[ -n "$results" ]]; then
        echo "  Found in:"
        echo "$results" | sed 's/^/    /'
    else
        echo "  No matches found"
    fi
}

function find-lwc() {
    if [ $# -eq 0 ]; then
        echo "Usage: find-lwc <search-term>"
        return 1
    fi
    
    echo "Searching for LWC files containing: $1"
    local results=$(find force-app/main/default/lwc -name "*.js" -o -name "*.html" -exec grep -l "$1" {} \; 2>/dev/null)
    
    if [[ -n "$results" ]]; then
        echo "  Found in:"
        echo "$results" | sed 's/^/    /'
    else
        echo "  No matches found"
    fi
}

# Enhanced LWC creation with project validation
function create-lwc-enhanced() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-lwc-enhanced <component-name>"
        return 1
    fi
    
    # Ensure we're in a Salesforce project
    if [[ ! -f "sfdx-project.json" ]]; then
        echo "Not in a Salesforce project directory"
        echo "  Please run this command from your Salesforce project root"
        return 1
    fi
    
    echo "Creating enhanced LWC: $1..."
    
    # Run command silently
    SF_AUTOUPDATE_DISABLE=true NODE_NO_WARNINGS=1 sf lightning generate component --type lwc --name "$1" --output-dir force-app/main/default/lwc >/dev/null 2>&1
    
    # Check if the component was created successfully
    if [[ -d "force-app/main/default/lwc/$1" ]]; then
        echo "  Created component directory: force-app/main/default/lwc/$1"
        echo "  Files created:"
        ls -la "force-app/main/default/lwc/$1" | grep -E "\.(js|html|xml)$" | awk '{print "    " $9}'
        echo "Enhanced LWC '$1' created successfully!"
    else
        echo "Failed to create enhanced LWC '$1'"
        return 1
    fi
}

# =============================================================================
# Salesforce CLI Environment (warnings suppressed)
# =============================================================================
if command -v sf >/dev/null 2>&1; then
    export SF_AUTOUPDATE_DISABLE=true
fi
