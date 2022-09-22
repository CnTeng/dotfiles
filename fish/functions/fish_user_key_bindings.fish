# Use vimlike keybindings for history
bind \ck history-search-backward
bind \cj history-search-forward
# Backward word
bind \ch backward-word
# AcceptNextSuggestionWord
bind \cl forward-word

# fzf keybindings
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
fzf_key_bindings
