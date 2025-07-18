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
alias apex-log='sf apex get log'
alias sf-export='sf data export tree'
alias sf-import='sf data import tree'
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
function sf-deploy() {
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
                echo "Usage: sf-deploy [-o target-org] [-x manifest] [-d source-dir] [-m metadata] [--dry-run] [--test-level level] [--run-tests]"
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
function sf-deploy-meta() {
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
function sf-retrieve() {
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

# Navigation shortcuts
function sfnav() {
    case "$1" in
        "classes"|"apex")
            cd force-app/main/default/classes && echo "→ Apex classes"
            ;;
        "triggers")
            cd force-app/main/default/triggers && echo "→ Apex triggers"
            ;;
        "lwc")
            cd force-app/main/default/lwc && echo "→ Lightning Web Components"
            ;;
        "aura")
            cd force-app/main/default/aura && echo "→ Aura components"
            ;;
        "objects")
            cd force-app/main/default/objects && echo "→ Custom objects"
            ;;
        "flows")
            cd force-app/main/default/flows && echo "→ Flows"
            ;;
        "config")
            cd config && echo "→ Config directory"
            ;;
        *)
            echo "Usage: sfnav {classes|triggers|lwc|aura|objects|flows|config}"
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
