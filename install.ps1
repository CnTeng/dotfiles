# Try to link the configs and detect errors
function Test-Config {
  [CmdletBinding()]
  Param([string]$SourcePath, [string]$TargetPath)
  [Bool]$IsError = $false
  try {
    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -ErrorAction Stop
  }
  catch {
    Write-Host "Error`n" -ForegroundColor red
    $IsError = $true
  }
  if ($IsError) {
    return
  }
  else {
    Write-Host "Success`n" -ForegroundColor green
  }
}

# The main function of link the configs
function Set-Config {
  [CmdletBinding()]
  Param([string]$Name, [string]$SourcePath, [string]$TargetPath)
  if (Test-Path $TargetPath) {
    Write-Host "The config of $Name exists." -ForegroundColor DarkBlue
    [string]$IsPermit = Read-Host "Remove the existing config and link a new one?(y or n)"
    if ($IsPermit -eq "y") {
      Remove-Item -Path $TargetPath -Recurse
      Test-Config $SourcePath $TargetPath
    }
    else {
      Write-Host "Exit`n" -ForegroundColor DarkGreen
      return
    }
  }
  else {
    [string]$IsInstall = Read-Host "Have you already installed" $Name "?(y or n)"
    if ($IsInstall -eq "y") {
      trylink $SourcePath $TargetPath
    }
    else {
      Write-Host "Exit`n" -ForegroundColor DarkGreen
      return
    }
  }
}

$Names = "neovim", "powershell", "powershell modules", "windows_terminal", "starship"
$SourcePaths = (
  "$Home\Code\dotfiles\neovim",
  "$Home\Code\dotfiles\powershell\Microsoft.Powershell_profile.ps1",
  "$Home\Code\dotfiles\powershell\Update-All",
  "$Home\Code\dotfiles\windows_terminal\settings.json",
  "$Home\Code\dotfiles\starship\starship.toml"
)
$TargetPaths = (
  "$Home\AppData\Local\nvim",
  "$Home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
  "$Home\Documents\powershell\modules\Update-All",
  "$Home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
  "$Home\.config\starship.toml"
)
for ($i = 0; $i -le ($Names.Length - 1); $i++) {
  Set-Config $Names[$i] $SourcePaths[$i] $TargetPaths[$i] 
}

# Set the proxy
$ProxyIp = "127.0.0.1"
$SocksPort = 10808
[string]$IsPermit = Read-Host "Set the proxys?(y or n)"
if ($IsPermit -eq "y") {
  Write-Host "Set the proxy of scoop" -ForegroundColor DarkBlue
  scoop config rm proxy
  scoop config proxy "socks5://$ProxyIp`:$SocksPort"

  Write-Host "Set the proxy of git" -ForegroundColor DarkBlue
  git config --global --unset user.name
  git config --global --unset user.email
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  git config --global --unset core.autocrlf
  git config --global user.name "CnTeng"
  git config --global user.email "tengyufei@live.com"
  git config --global http.proxy "socks5://$ProxyIp`:$SocksPort"
  git config --global https.proxy "socks5://$ProxyIp`:$SocksPort"
  git config --global core.autocrlf true

  Write-Host "Set the proxy of npm" -ForegroundColor DarkBlue
  npm config delete proxy
  npm config delete https-proxy
  npm config set proxy "socks5://$ProxyIp`:$SocksPort"
  npm config set https-proxy "socks5://$ProxyIp`:$SocksPort"

  Write-Host "Set the source of conda" -ForegroundColor DarkBlue
  conda config --remove-key default_channels
  conda config --set show_channel_urls yes
  conda config --add default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  conda config --add default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  conda config --add default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
}
