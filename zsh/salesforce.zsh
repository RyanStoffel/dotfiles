# =============================================================================
# Salesforce Development Configuration
# =============================================================================

export SF_AUTOUPDATE_DISABLE=true
export SF_LOG_LEVEL=error

# Salesforce CLI aliases
alias sf-login='sf org login web'
alias sf-logout='sf org logout'
alias sf-status='sf org list'
alias sf-info='sf org display'
alias sf-open='sf org open'
alias sf-query='sf data query'

# =============================================================================
# Salesforce Development Functions
# =============================================================================

# Create Lightning Web Component
function create-lwc() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-lwc <component-name>"
        return 1
    fi
    
    echo "Creating LWC: $1..."
    sf lightning generate component --type lwc --output-dir force-app/main/default/lwc --name "$1" >/dev/null 2>&1
    
    if [[ -d "force-app/main/default/lwc/$1" ]]; then
        echo "✓ Created: force-app/main/default/lwc/$1"
        ls -la "force-app/main/default/lwc/$1" | grep -E "\.(js|html|xml)$" | awk '{print "  " $9}'
    else
        echo "✗ Failed to create LWC '$1'"
        return 1
    fi
}

# Create Apex Class
function create-apex() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-apex <class-name>"
        return 1
    fi
    
    echo "Creating Apex class: $1..."
    sf apex generate class --name "$1" --output-dir force-app/main/default/classes >/dev/null 2>&1
    
    if [[ -f "force-app/main/default/classes/$1.cls" ]]; then
        echo "✓ Created: force-app/main/default/classes/$1.cls"
        echo "✓ Created: force-app/main/default/classes/$1.cls-meta.xml"
    else
        echo "✗ Failed to create Apex class '$1'"
        return 1
    fi
}

# Create Apex Trigger
function create-trigger() {
    if [ $# -eq 0 ]; then
        echo "Usage: create-trigger <trigger-name>"
        return 1
    fi
    
    echo "Creating Apex trigger: $1..."
    sf apex generate trigger --name "$1" --output-dir force-app/main/default/triggers >/dev/null 2>&1
    
    if [[ -f "force-app/main/default/triggers/$1.trigger" ]]; then
        echo "✓ Created: force-app/main/default/triggers/$1.trigger"
        echo "✓ Created: force-app/main/default/triggers/$1.trigger-meta.xml"
    else
        echo "✗ Failed to create Apex trigger '$1'"
        return 1
    fi
}

# Deploy using sf project deploy start
function deploy() {
    local target_org=""
    local manifest=""
    local source_dir=""
    local metadata=""
    local dry_run=""
    local test_level=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -o|--target-org)
                target_org="--target-org $2"
                shift 2
                ;;
            -x|--manifest)
                manifest="--manifest $2"
                shift 2
                ;;
            -d|--source-dir)
                source_dir="--source-dir $2"
                shift 2
                ;;
            -m|--metadata)
                metadata="--metadata $2"
                shift 2
                ;;
            --dry-run)
                dry_run="--dry-run"
                shift
                ;;
            --test-level)
                test_level="--test-level $2"
                shift 2
                ;;
            --run-tests)
                test_level="--test-level RunLocalTests"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: deploy [-o target-org] [-x manifest] [-d source-dir] [-m metadata] [--dry-run] [--test-level level] [--run-tests]"
                return 1
                ;;
        esac
    done
    
    if [[ -n "$dry_run" ]]; then
        echo "Validating deployment (dry run)..."
    else
        echo "Deploying to org..."
    fi
    
    local cmd="sf project deploy start $target_org $manifest $source_dir $metadata $dry_run $test_level"
    echo "Running: $cmd"
    
    if eval $cmd >/dev/null 2>&1; then
        if [[ -n "$dry_run" ]]; then
            echo "✓ Validation completed successfully"
        else
            echo "✓ Deploy completed successfully"
        fi
    else
        if [[ -n "$dry_run" ]]; then
            echo "✗ Validation failed"
        else
            echo "✗ Deploy failed"
        fi
        return 1
    fi
}

# Deploy using sf deploy metadata
function deploy-metadata() {
    local target_org=""
    local manifest=""
    local source_dir=""
    local metadata=""
    local dry_run=""
    local test_level=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -o|--target-org)
                target_org="--target-org $2"
                shift 2
                ;;
            -x|--manifest)
                manifest="--manifest $2"
                shift 2
                ;;
            -d|--source-dir)
                source_dir="--source-dir $2"
                shift 2
                ;;
            -m|--metadata)
                metadata="--metadata $2"
                shift 2
                ;;
            --dry-run)
                dry_run="--dry-run"
                shift
                ;;
            --test-level)
                test_level="--test-level $2"
                shift 2
                ;;
            --run-tests)
                test_level="--test-level RunLocalTests"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: sf-deploy-meta [-o target-org] [-x manifest] [-d source-dir] [-m metadata] [--dry-run] [--test-level level] [--run-tests]"
                return 1
                ;;
        esac
    done
    
    if [[ -n "$dry_run" ]]; then
        echo "Validating metadata deployment (dry run)..."
    else
        echo "Deploying metadata..."
    fi
    
    local cmd="sf deploy metadata $target_org $manifest $source_dir $metadata $dry_run $test_level"
    echo "Running: $cmd"
    
    if eval $cmd >/dev/null 2>&1; then
        if [[ -n "$dry_run" ]]; then
            echo "✓ Metadata validation completed successfully"
        else
            echo "✓ Metadata deploy completed successfully"
        fi
    else
        if [[ -n "$dry_run" ]]; then
            echo "✗ Metadata validation failed"
        else
            echo "✗ Metadata deploy failed"
        fi
        return 1
    fi
}

# Retrieve metadata
function retrieve() {
    local target_org=""
    local manifest=""
    local metadata=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -o|--target-org)
                target_org="--target-org $2"
                shift 2
                ;;
            -x|--manifest)
                manifest="--manifest $2"
                shift 2
                ;;
            -m|--metadata)
                metadata="--metadata $2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: sf-retrieve [-o target-org] [-x manifest] [-m metadata]"
                return 1
                ;;
        esac
    done
    
    echo "Retrieving metadata..."
    local cmd="sf project retrieve start $target_org $manifest $metadata"
    echo "Running: $cmd"
    
    if eval $cmd >/dev/null 2>&1; then
        echo "✓ Retrieve completed successfully"
    else
        echo "✗ Retrieve failed"
        return 1
    fi
}

# Convert metadata format
function convert() {
    local source_dir=""
    local metadata=""
    local manifest=""
    local output_dir=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--source-dir)
                source_dir="--source-dir $2"
                shift 2
                ;;
            -m|--metadata)
                metadata="--metadata $2"
                shift 2
                ;;
            -x|--manifest)
                manifest="--manifest $2"
                shift 2
                ;;
            -o|--output-dir)
                output_dir="--output-dir $2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: sf-convert [-d source-dir] [-m metadata] [-x manifest] [-o output-dir]"
                return 1
                ;;
        esac
    done
    
    echo "Converting metadata format..."
    local cmd="sf project convert source $source_dir $metadata $manifest $output_dir"
    echo "Running: $cmd"
    
    if eval $cmd >/dev/null 2>&1; then
        echo "✓ Convert completed successfully"
    else
        echo "✗ Convert failed"
        return 1
    fi
}

# Navigation shortcuts
function sfnav() {
    case "$1" in
        "applications")
            cd force-app/main/default/applications && echo "→ Applications"
            ;;
        "aura")
            cd force-app/main/default/aura && echo "→ Aura components"
            ;;
        "bots")
            cd force-app/main/default/bots && echo "→ Bots"
            ;;
        "classes"|"apex")
            cd force-app/main/default/classes && echo "→ Apex classes"
            ;;
        "contentassets")
            cd force-app/main/default/contentassets && echo "→ Content assets"
            ;;
        "csptrustedsites")
            cd force-app/main/default/cspTrustedSites && echo "→ CSP trusted sites"
            ;;
        "externalcredentials")
            cd force-app/main/default/externalCredentials && echo "→ External credentials"
            ;;
        "flexipages")
            cd force-app/main/default/flexipages && echo "→ Flexi pages"
            ;;
        "flows")
            cd force-app/main/default/flows && echo "→ Flows"
            ;;
        "genaifunctions")
            cd force-app/main/default/genAiFunctions && echo "→ Gen AI functions"
            ;;
        "genaiplannerbundles")
            cd force-app/main/default/genAiPlannerBundles && echo "→ Gen AI planner bundles"
            ;;
        "genaiplannertemplates")
            cd force-app/main/default/genAiPromptTemplates && echo "→ Gen AI prompt templates"
            ;;
        "genaiplugins")
            cd force-app/main/default/genAiPlugins && echo "→ Gen AI plugins"
            ;;
        "layouts")
            cd force-app/main/default/layouts && echo "→ Layouts"
            ;;
        "lwc")
            cd force-app/main/default/lwc && echo "→ Lightning Web Components"
            ;;
        "namedcredentials")
            cd force-app/main/default/namedCredentials && echo "→ Named credentials"
            ;;
        "notificationtypes")
            cd force-app/main/default/notificationtypes && echo "→ Notification types"
            ;;
        "objects")
            cd force-app/main/default/objects && echo "→ Custom objects"
            ;;
        "pages")
            cd force-app/main/default/pages && echo "→ Visualforce pages"
            ;;
        "permissionsets")
            cd force-app/main/default/permissionsets && echo "→ Permission sets"
            ;;
        "profiles")
            cd force-app/main/default/profiles && echo "→ Profiles"
            ;;
        "quickactions")
            cd force-app/main/default/quickActions && echo "→ Quick actions"
            ;;
        "staticresources")
            cd force-app/main/default/staticresources && echo "→ Static resources"
            ;;
        "tabs")
            cd force-app/main/default/tabs && echo "→ Tabs"
            ;;
        "triggers")
            cd force-app/main/default/triggers && echo "→ Apex triggers"
            ;;
        "config")
            cd config && echo "→ Config directory"
            ;;
        "manifest")
            cd manifest && echo "→ Manifest directory"
            ;;
        "list")
            echo "Available navigation options:"
            echo "  applications          - Applications"
            echo "  aura                  - Aura components"
            echo "  bots                  - Bots"
            echo "  classes|apex          - Apex classes"
            echo "  contentassets         - Content assets"
            echo "  csptrustedsites       - CSP trusted sites"
            echo "  externalcredentials   - External credentials"
            echo "  flexipages            - Flexi pages"
            echo "  flows                 - Flows"
            echo "  genaifunctions        - Gen AI functions"
            echo "  genaiplannerbundles   - Gen AI planner bundles"
            echo "  genaiplannertemplates - Gen AI prompt templates"
            echo "  genaiplugins          - Gen AI plugins"
            echo "  layouts               - Page Layouts"
            echo "  lwc                   - Lightning Web Components"
            echo "  namedcredentials      - Named credentials"
            echo "  notificationtypes     - Notification types"
            echo "  objects               - Custom objects"
            echo "  pages                 - Visualforce pages"
            echo "  permissionsets        - Permission sets"
            echo "  profiles              - Profiles"
            echo "  quickactions          - Quick actions"
            echo "  staticresources       - Static resources"
            echo "  tabs                  - Custom Tabs"
            echo "  triggers              - Apex triggers"
            echo "  config                - Config directory"
            echo "  manifest              - Manifest directory"
            ;;
        *)
            echo "Usage: sfnav {option}"
            echo "Run 'sfnav list' to see all available options"
            ;;
    esac
}

# Quick test runner
function apex-test() {
    if [ $# -eq 0 ]; then
        echo "Running all Apex tests..."
        sf apex run test --wait 10 --result-format human >/dev/null 2>&1
    else
        echo "Running test class: $1..."
        sf apex run test --class-names "$1" --wait 10 --result-format human >/dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo "✓ Tests completed successfully"
    else
        echo "✗ Tests failed"
        return 1
    fi
}
