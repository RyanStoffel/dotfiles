# Function to safely source files
safe_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
        return 0
    fi
    return 1
}

# Find home-manager profile path across different systems
find_hm_profile() {
    # Home-manager profile locations for different systems
    local hm_paths=(
        # NixOS home-manager locations
        "$HOME/.local/state/nix/profiles/home-manager/home-path"
        "$HOME/.local/state/home-manager/profiles/home-manager/home-path"
        
        # nix-darwin home-manager locations
        "$HOME/.local/state/nix/profiles/home-manager"
        "/nix/var/nix/profiles/per-user/$USER/home-manager"
        
        # Fallback user profiles
        "$HOME/.nix-profile"
        "/nix/var/nix/profiles/per-user/$USER/profile"
        
        # System profiles
        "/run/current-system/sw"
        "/etc/profiles/per-user/$USER"
    )
    
    local found_paths=()
    for path in "${hm_paths[@]}"; do
        if [[ -d "$path/share" ]]; then
            found_paths+=("$path")
        fi
    done
    
    # Return all found paths
    printf '%s\n' "${found_paths[@]}"
}

# Dynamic plugin discovery with cross-platform support
find_plugin() {
    local plugin_name="$1"
    
    # Get all available home-manager profile paths
    local hm_profiles=($(find_hm_profile))
    
    # Build comprehensive search paths
    local search_paths=()
    
    # Add home-manager profile paths
    for profile in "${hm_profiles[@]}"; do
        search_paths+=("${profile}/share")
    done
    
    # Add additional common paths
    search_paths+=(
        # macOS specific paths
        "/opt/homebrew/share"
        "/usr/local/share" 
        
        # Linux specific paths
        "/usr/share"
        "/run/current-system/sw/share"
        "/nix/var/nix/profiles/default/share"
    )
    
    # Also search in nix store directly (as fallback)
    local nix_store_paths=($(find /nix/store -maxdepth 1 -name "*${plugin_name}*" -type d 2>/dev/null | head -3))
    
    # Combine all search paths, filtering out duplicates and non-existent paths
    local all_paths=()
    local seen_paths=()
    
    for path in "${search_paths[@]}" "${nix_store_paths[@]}"; do
        # Skip if path is empty, doesn't exist, or we've already seen it
        if [[ -n "$path" && -d "$path" ]] && [[ ! " ${seen_paths[*]} " =~ " ${path} " ]]; then
            all_paths+=("$path")
            seen_paths+=("$path")
        fi
    done
    
    # Search for plugin files in all paths
    for path in "${all_paths[@]}"; do
        # Standard location: path/plugin-name/plugin-name.zsh
        local plugin_file="${path}/${plugin_name}/${plugin_name}.zsh"
        if [[ -f "$plugin_file" ]]; then
            echo "$plugin_file"
            return 0
        fi
        
        # Alternative location: path/plugin-name.zsh
        local alt_file="${path}/${plugin_name}.zsh"
        if [[ -f "$alt_file" ]]; then
            echo "$alt_file"
            return 0
        fi
    done
    
    return 1
}

# Detect system type for better error messages
get_system_type() {
    if [[ $(uname) == "Darwin" ]]; then
        echo "nix-darwin"
    elif [[ -f /etc/nixos/configuration.nix ]]; then
        echo "NixOS"
    else
        echo "unknown"
    fi
}

# Load zsh-autosuggestions
echo "🔍 Looking for zsh-autosuggestions on $(get_system_type)..."
if plugin_file=$(find_plugin "zsh-autosuggestions"); then
    if safe_source "$plugin_file"; then
        echo "✓ Loaded zsh-autosuggestions from: $plugin_file"
        # Configure autosuggestions
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_USE_ASYNC=true
    fi
else
    local system=$(get_system_type)
    echo "⚠️  zsh-autosuggestions not found on $system"
    case $system in
        "nix-darwin")
            echo "   Try: rebuild (darwin-rebuild)"
            ;;
        "NixOS")
            echo "   Try: rebuild-home"
            ;;
        *)
            echo "   Try: nix-env -iA nixpkgs.zsh-autosuggestions"
            ;;
    esac
fi

# Load zsh-syntax-highlighting  
echo "🔍 Looking for zsh-syntax-highlighting on $(get_system_type)..."
if plugin_file=$(find_plugin "zsh-syntax-highlighting"); then
    if safe_source "$plugin_file"; then
        echo "✓ Loaded zsh-syntax-highlighting from: $plugin_file"
    fi
else
    local system=$(get_system_type)
    echo "⚠️  zsh-syntax-highlighting not found on $system"
    case $system in
        "nix-darwin")
            echo "   Try: rebuild (darwin-rebuild)"
            ;;
        "NixOS")
            echo "   Try: rebuild-home"
            ;;
        *)
            echo "   Try: nix-env -iA nixpkgs.zsh-syntax-highlighting"
            ;;
    esac
fi

# Debug information (remove this after testing)
if [[ "${ZSH_DEBUG_PLUGINS:-}" == "1" ]]; then
    echo "🐛 Debug: Found home-manager profiles:"
    find_hm_profile | while read profile; do
        echo "   $profile"
        ls -la "$profile/share/" 2>/dev/null | grep zsh || echo "     No zsh packages"
    done
fi

# Plugin configuration
if (( ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} )); then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi
