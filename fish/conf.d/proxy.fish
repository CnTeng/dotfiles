# Set the host_ip and proxy port
set host_ip "127.0.0.1"
set socks_port 10808
set http_port 10809

# Set the name of wsl and pad
set wsl_name "rxdell"
set pad_name "rxsf"

# Set proxy for shell tools such as apt
function global_proxy
  set -gx http_proxy http://$host_ip:$http_port
  set -gx https_proxy http://$host_ip:$http_port
end

# Set proxy for git
function git_proxy
  git config --global --unset user.name
  git config --global --unset user.email
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  git config --global user.name "CnTeng"
  git config --global user.email "tengyufei@live.com"
  git config --global http.proxy "http://$host_ip:$http_port"
  git config --global https.proxy "http://$host_ip:$http_port"
end

# Set proxy for ssh
function ssh_proxy
  rm -rf ~/.ssh/config
  echo "nc -v -x $host_ip:$http_port %h %p" >> ~/.ssh/config
  echo "Host github.com" >> ~/.ssh/config
  echo "  User git" >> ~/.ssh/config
  echo "  Port 22" >> ~/.ssh/config
  echo "  Hostname github.com" >> ~/.ssh/config
  echo "  IdentityFile "~/.ssh/id_ed25519"" >> ~/.ssh/config
  echo "  TCPKeepAlive yes" >> ~/.ssh/config
  echo "Host ssh.github.com" >> ~/.ssh/config
  echo "  User git" >> ~/.ssh/config
  echo "  Port 443" >> ~/.ssh/config
  echo "  Hostname ssh.github.com" >> ~/.ssh/config
  echo "  IdentityFile "~/.ssh/id_ed25519"" >> ~/.ssh/config
  echo "  TCPKeepAlive yes" >> ~/.ssh/config
end

# Set proxy for npm
function npm_proxy
  npm config delete proxy
  npm config delete https-proxy
  npm config set proxy "socks5://$host_ip:$socks_port"
  npm config set https-proxy "socks5://$host_ip:$socks_port"
end

# Set proxy which is login
if status is-login
  switch $hostname 
    case $wsl_name
      set host_ip (cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
      set socks_port 10810
      set http_port 10811
      global_proxy
      git_proxy
      ssh_proxy
      npm_proxy
    case $pad_name
      global_proxy
      git_proxy
      npm_proxy
  end
end
