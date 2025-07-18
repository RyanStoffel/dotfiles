#!/bin/bash
# =============================================================================
# Zsh Configuration Test Suite
# =============================================================================
# This script tests all aspects of the modular Zsh configuration

echo "🧪 Testing Modular Zsh Configuration"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Test function
test_command() {
    local test_name="$1"
    local command="$2"
    local expected_result="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -n "Testing $test_name... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "  ${YELLOW}Command: $command${NC}"
    fi
}

# Test alias function
test_alias() {
    local alias_name="$1"
    local test_name="alias '$alias_name'"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -n "Testing $test_name... "
    
    if alias "$alias_name" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test function existence
test_function() {
    local func_name="$1"
    local test_name="function '$func_name'"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -n "Testing $test_name... "
    
    if declare -f "$func_name" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo -e "\n${BLUE}1. Testing Module Loading${NC}"
echo "------------------------"

# Test if main config loaded
if [[ -n "$ZDOTDIR" ]]; then
    echo -e "ZDOTDIR set: ${GREEN}✅ $ZDOTDIR${NC}"
else
    echo -e "ZDOTDIR: ${RED}❌ Not set${NC}"
fi

# Test module files exist
modules=("aliases" "environment" "functions" "history" "options" "keybindings" "completion" "integrations")
for module in "${modules[@]}"; do
    if [[ -f "$HOME/.dotfiles/zsh/modules/$module.zsh" ]]; then
        echo -e "Module $module.zsh: ${GREEN}✅ Found${NC}"
    else
        echo -e "Module $module.zsh: ${RED}❌ Missing${NC}"
    fi
done

echo -e "\n${BLUE}2. Testing Environment Variables${NC}"
echo "-------------------------------"

# Test PATH additions
test_command "Emacs in PATH" "echo \$PATH | grep -q '.config/emacs/bin'"
test_command "Local bin in PATH" "echo \$PATH | grep -q '.local/bin'"

# Test environment variables
if [[ -n "$EDITOR" ]]; then
    echo -e "EDITOR: ${GREEN}✅ $EDITOR${NC}"
else
    echo -e "EDITOR: ${YELLOW}⚠️  Not set${NC}"
fi

echo -e "\n${BLUE}3. Testing Aliases${NC}"
echo "----------------"

# Test general aliases
test_alias "ll"
test_alias "c"
test_alias "cat"

# Test git aliases
git_aliases=("gs" "ga" "gaa" "gc" "gco" "gb" "gd" "gl" "gp" "gpl" "gpom" "gcb" "gcom" "gst")
for alias in "${git_aliases[@]}"; do
    test_alias "$alias"
done

# Test development aliases
test_alias "rebuild"

echo -e "\n${BLUE}4. Testing Functions${NC}"
echo "------------------"

# Test custom functions
test_function "mkcd"
test_function "gclone"
test_function "dev"
test_function "proj"
test_function "extract"
test_function "ff"
test_function "psg"

# Test Salesforce functions if salesforce.zsh is loaded
if [[ -f "$HOME/.dotfiles/zsh/salesforce.zsh" ]] && grep -q "salesforce.zsh" "$HOME/.dotfiles/zsh/config.zsh" 2>/dev/null; then
    test_function "sf-org"
    test_function "apex-test"
    test_function "salesforce-nav"
fi

echo -e "\n${BLUE}5. Testing Tool Integrations${NC}"
echo "---------------------------"

# Test starship
if command -v starship >/dev/null 2>&1; then
    test_command "Starship prompt" "echo \$PS1 | grep -q starship || [[ -n \$STARSHIP_SHELL ]]"
else
    echo -e "Starship: ${YELLOW}⚠️  Not installed${NC}"
fi

# Test zoxide
if command -v zoxide >/dev/null 2>&1; then
    test_command "Zoxide integration" "declare -f __zoxide_z >/dev/null"
else
    echo -e "Zoxide: ${YELLOW}⚠️  Not installed${NC}"
fi

# Test fastfetch
test_command "Fastfetch available" "command -v fastfetch"

# Test fzf integration
if command -v fzf >/dev/null 2>&1; then
    test_command "FZF key bindings" "bindkey | grep -q fzf"
else
    echo -e "FZF: ${YELLOW}⚠️  Not installed${NC}"
fi

echo -e "\n${BLUE}6. Testing Zsh Options${NC}"
echo "--------------------"

# Test important zsh options
test_command "Auto CD enabled" "[[ -o autocd ]]"
test_command "Auto pushd enabled" "[[ -o autopushd ]]"
test_command "Extended glob enabled" "[[ -o extendedglob ]]"
test_command "Share history enabled" "[[ -o sharehistory ]]"

echo -e "\n${BLUE}7. Testing History Configuration${NC}"
echo "------------------------------"

test_command "History file exists" "[[ -f \$HISTFILE ]]"
test_command "History size set" "[[ \$HISTSIZE -gt 0 ]]"
test_command "Save history set" "[[ \$SAVEHIST -gt 0 ]]"

echo -e "\n${BLUE}8. Testing Key Bindings${NC}"
echo "---------------------"

test_command "Emacs key bindings" "[[ \$KEYMAP == 'emacs' ]] || bindkey | grep -q '^\"^A'"
test_command "History search binding" "bindkey | grep -q '^\"^R'"
test_command "Word movement bindings" "bindkey | grep -q '\\[1;3C'"

echo -e "\n${BLUE}9. Testing Completion System${NC}"
echo "---------------------------"

test_command "Completion system loaded" "declare -f compinit >/dev/null"
test_command "Completion cache directory" "[[ -d ~/.zsh/cache ]]"

# Test specific completions
if command -v git >/dev/null 2>&1; then
    test_command "Git completion" "complete -p git >/dev/null 2>&1 || compctl -d git >/dev/null 2>&1"
fi

echo -e "\n${BLUE}10. Testing Plugin Integration${NC}"
echo "-----------------------------"

# Test zsh-autosuggestions
if [[ -d "$HOME/.zsh/plugins/zsh-autosuggestions" ]]; then
    test_command "Autosuggestions plugin" "declare -f _zsh_autosuggest_start >/dev/null"
else
    echo -e "Autosuggestions: ${YELLOW}⚠️  Plugin directory not found${NC}"
fi

# Test zsh-syntax-highlighting
if [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then
    test_command "Syntax highlighting plugin" "declare -f _zsh_highlight >/dev/null"
else
    echo -e "Syntax highlighting: ${YELLOW}⚠️  Plugin directory not found${NC}"
fi

echo -e "\n${BLUE}11. Performance Test${NC}"
echo "------------------"

# Test shell startup time
echo -n "Testing shell startup time... "
startup_time=$(time ( zsh -c 'exit' ) 2>&1 | grep real | awk '{print $2}')
if [[ -n "$startup_time" ]]; then
    echo -e "${GREEN}✅ $startup_time${NC}"
else
    echo -e "${YELLOW}⚠️  Could not measure${NC}"
fi

echo -e "\n${BLUE}12. Configuration Syntax Test${NC}"
echo "----------------------------"

# Test each module for syntax errors
for module in "${modules[@]}"; do
    module_file="$HOME/.dotfiles/zsh/modules/$module.zsh"
    if [[ -f "$module_file" ]]; then
        if zsh -n "$module_file" 2>/dev/null; then
            echo -e "$module.zsh syntax: ${GREEN}✅ Valid${NC}"
        else
            echo -e "$module.zsh syntax: ${RED}❌ Error${NC}"
        fi
    fi
done

# Test main config file
if zsh -n "$HOME/.dotfiles/zsh/config.zsh" 2>/dev/null; then
    echo -e "config.zsh syntax: ${GREEN}✅ Valid${NC}"
else
    echo -e "config.zsh syntax: ${RED}❌ Error${NC}"
fi

echo -e "\n${BLUE}===================================="
echo -e "📊 Test Results Summary"
echo -e "=====================================${NC}"
echo -e "Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n🎉 ${GREEN}All tests passed! Your Zsh configuration is working perfectly!${NC}"
else
    echo -e "\n⚠️  ${YELLOW}Some tests failed. Check the output above for details.${NC}"
fi

echo -e "\n${BLUE}Quick Manual Tests:${NC}"
echo "1. Type 'gs' - should show git status"
echo "2. Type 'll' - should show detailed file listing" 
echo "3. Type 'c' - should clear screen"
echo "4. Press Tab for completion"
echo "5. Press Ctrl+R for history search"
echo "6. Check if your prompt looks correct (Starship)"
echo "7. Try 'cd' with a directory name (should work with zoxide)"

echo -e "\n${BLUE}Development-Specific Tests:${NC}"
echo "1. Type 'rebuild' - should show nix-darwin rebuild command"
echo "2. If in Salesforce project, try 'sfnav list'"
echo "3. Test custom functions like 'mkcd test-dir'"

echo -e "\n${BLUE}Performance Check:${NC}"
echo "1. Open a new terminal tab - should load quickly"
echo "2. Try Tab completion - should be responsive"
echo "3. History search should be fast"
