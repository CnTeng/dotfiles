#!/bin/bash

# Link the configs and detect errors
link_config() {
  sc_path=$1
  tg_path=$2
  ln -s $sc_path $tg_path
  if [ $? -ne 0 ]; then
    echo -e "\e[31mError\n\e[0m"
  else 
    echo -e "\e[32mSuccess\n\e[0m"
  fi
}

# The main function of setting configs
set_config() {
  name=$1
  cmd=$2
  sc_path=$3
  tg_path=$4
  type $cmd
  if [ $? -eq 0 ]; then
    if [ -e $tg_path ]; then
      echo -e "\e[34mThe config of $name exists.\e[0m"
      echo -e "\e[34mRemove the existing config and link a new one?(y or n) \c\e[0m"
      read is_permit
      if [ $is_permit = "y" ]; then
        rm -rf $tg_path
        link_config $sc_path $tg_path
      else 
        echo -e "\e[34mExit\n\e[0m"
        return
      fi
    else 
      link_config $sc_path $tg_path
    fi
  else 
    echo -e "\e[34m$name isn't installed.\e[0m"
    echo -e "\e[34mForce link the config?(y or n) \c\e[0m"
    read is_force
    if [ $is_force = "y" ]; then
      link_config $sc_path $tg_path
    else
      echo -e "\e[34mExit\n\e[0m"
      return
    fi
  fi
}

names=(fish_proxy fish_config fish_plugins fish_fun neovim tmux.conf starship)
cmd=(fish fish fish fish nvim tmux tmux starship)
sc_paths=(
  ~/Code/dotfiles/fish/conf.d/proxy.fish
  ~/Code/dotfiles/fish/config.fish
  ~/Code/dotfiles/fish/fish_plugins
  ~/Code/dotfiles/fish/functions/fish_user_key_bindings.fish
  ~/Code/dotfiles/neovim
  ~/Code/dotfiles/tmux/.tmux.conf
  ~/Code/dotfiles/starship/starship.toml
)
tg_paths=(
  ~/.config/fish/conf.d/proxy.fish
  ~/.config/fish/config.fish
  ~/.config/fish/fish_plugins
  ~/.config/fish/functions/fish_user_key_bindings.fish
  ~/.config/nvim
  ~/.tmux.conf
  ~/.config/starship.toml
)

for i in $(seq 0 $[ ${#names[@]}-1 ]); do
  set_config ${names[$i]} ${cmd[$i]} ${sc_paths[$i]} ${tg_paths[$i]}
done

fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher update"
fish -c "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"

# sudo ln -s "C:/Program Files/Neovim/bin/win32yank.exe" "/usr/local/bin/win32yank.exe"
