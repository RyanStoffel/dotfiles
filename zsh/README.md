# Modular Zsh Configuration

This directory contains a modular Zsh configuration that separates different concerns into individual files for better organization and maintainability.

## Structure

```
~/.dotfiles/zsh/
├── config.zsh              # Main configuration file that loads all modules
├── modules/                 # Core configuration modules
│   ├── aliases.zsh         # All aliases (general, git, development)
│   ├── completion.zsh      # Zsh completion system configuration
│   ├── environment.zsh     # Environment variables and PATH setup
│   ├── functions.zsh       # Custom shell functions
│   ├── history.zsh         # History configuration and options
│   ├── integrations.zsh    # Tool integrations (starship, zoxide, fzf, etc.)
│   ├── keybindings.zsh     # Key bindings and input configuration
│   └── options.zsh         # Zsh shell options and behavior
├── salesforce.zsh          # Salesforce development specific configuration
├── local.zsh.example       # Template for local customizations
└── README.md               # This file
```

## Module Descriptions

### Core Modules (in `/modules/`)

1. **environment.zsh** - Environment variables, PATH configuration, and development environment setup
2. **options.zsh** - Zsh shell options that control behavior (auto-cd, globbing, etc.)
3. **history.zsh** - History file configuration, size limits, and history options
4. **completion.zsh** - Zsh completion system setup, styling, and tool-specific completions
5. **keybindings.zsh** - Key bindings for navigation, editing, and custom functions
6. **functions.zsh** - Custom shell functions for development and utilities
7. **aliases.zsh** - All aliases organized by category (general, git, development)
8. **integrations.zsh** - Integration with external tools (starship, zoxide, fzf, etc.)

### Specialized Configurations

- **salesforce.zsh** - Salesforce development specific aliases, functions, and environment
- **local.zsh** - Local machine customizations (not version controlled)
- **$(hostname).zsh** - Machine-specific configurations
- **work.zsh** - Work-specific configurations

## Usage

### With Nix-Darwin (Recommended)
The configuration is designed to work with nix-darwin. Update your `home.nix` to use the modular configuration:

```nix
programs.zsh = {
  enable = true;
  initContent = ''
    source "$HOME/.dotfiles/zsh/config.zsh"
  '';
  # ... rest of your zsh configuration
};
```

### Manual Setup
If not using nix-darwin, add this to your `.zshrc`:

```bash
source "$HOME/.dotfiles/zsh/config.zsh"
```

## Customization

### Adding Local Customizations
1. Copy `local.zsh.example` to `local.zsh`
2. Add your personal customizations to `local.zsh`
3. The file is automatically loaded if it exists

### Adding Machine-Specific Config
Create a file named after your hostname:
```bash
touch ~/.dotfiles/zsh/$(hostname).zsh
```

### Adding Work-Specific Config
Create a work configuration file:
```bash
touch ~/.dotfiles/zsh/work.zsh
```

### Project-Specific Configurations
The configuration automatically detects project types and loads appropriate configs:
- Salesforce projects (looks for `sfdx-project.json`)
- Node.js projects (looks for `package.json`)

## Development Workflow

### For Salesforce Development
The configuration includes specialized Salesforce development tools:
- SF CLI aliases and functions
- Apex development shortcuts
- Org management helpers
- Project navigation functions

Use `sf-scratch <name>` to create scratch orgs, `sfnav classes` to navigate to Apex classes, etc.

### Adding New Modules
1. Create a new `.zsh` file in the `modules/` directory
2. Add the source line to `config.zsh` in the appropriate load order
3. Follow the existing pattern of organizing by functionality

## Load Order

The modules are loaded in a specific order to ensure dependencies are met:

1. **environment.zsh** - Sets up environment variables
2. **options.zsh** - Configures shell behavior
3. **history.zsh** - Sets up history
4. **completion.zsh** - Initializes completion system
5. **keybindings.zsh** - Sets up key bindings
6. **functions.zsh** - Loads custom functions
7. **aliases.zsh** - Loads aliases (may depend on functions)
8. **integrations.zsh** - Initializes external tools

## Benefits of This Approach

1. **Modularity** - Easy to enable/disable specific features
2. **Maintainability** - Changes are isolated to specific files
3. **Reusability** - Modules can be shared across different setups
4. **Performance** - Only load what you need
5. **Organization** - Related configurations are grouped together
6. **Debugging** - Easy to identify which module causes issues

## Performance Tips

- Comment out unused tool integrations in `integrations.zsh`
- Use the profiling section in `config.zsh` to identify slow loading modules
- Consider lazy-loading expensive integrations

## Troubleshooting

### Module Not Loading
1. Check if the file exists and is readable
2. Verify the source path in `config.zsh`
3. Check for syntax errors in the module file

### Performance Issues
1. Enable profiling in `config.zsh`
2. Run `zprof` to see which modules are slow
3. Consider lazy-loading or removing unused integrations

### Plugin Conflicts
1. Check load order in `config.zsh`
2. Verify plugin configurations don't conflict
3. Use `which` command to check if functions are being overridden

## Contributing

When adding new features:
1. Add them to the appropriate module
2. Update this README if adding new modules
3. Follow the existing code style and organization
4. Test on a clean shell session

## Backup

Before making major changes, backup your current configuration:
```bash
cp ~/.zshrc ~/.zshrc.backup
```

The modular approach makes it easy to revert specific changes by commenting out module loads in `config.zsh`.
