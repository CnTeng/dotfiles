if status is-login
  fish_config theme choose "Catppuccin Macchiato"
  set -U fish_greeting
end
starship init fish | source
zoxide init fish | source

