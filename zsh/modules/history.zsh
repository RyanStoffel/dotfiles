# history config
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# history options
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE         
setopt HIST_SAVE_NO_DUPS         
setopt HIST_REDUCE_BLANKS        
setopt HIST_VERIFY             
setopt SHARE_HISTORY           
setopt APPEND_HISTORY           
setopt INC_APPEND_HISTORY    
