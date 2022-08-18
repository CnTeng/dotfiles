function trylink {
  [CmdletBinding()]
  Param([string]$SourcePath, [string]$TargetPath)
  [Bool]$iserror = $false
  try {
    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -ErrorAction Stop
  } catch{
    Write-Host "Error" -ForegroundColor red
    Write-Host "`n"
    $iserror = $true
  }
  if ($iserror) {
    return
  } else {
    Write-Host "Link configuration successfully." -ForegroundColor green
    Write-Host "`n"
  }
}

function linkconfig {
  [CmdletBinding()]
  Param([string]$Name, [string]$SourcePath, [string]$TargetPath)
  if (Test-Path $TargetPath) {
    Write-Host "The configuration of $Name exists."
    [string]$ispermit = Read-Host "Do you permit to remove the existing configuration and link a new file?(y or n)"
    if ($ispermit -eq "y") {
      Remove-Item -Path $TargetPath -Recurse
      trylink $SourcePath $TargetPath
    } else {
      Write-Host "Exit"
      Write-Host "`n"
      return
    }
  } else {
    trylink $SourcePath $TargetPath
    return
  }
}

# neovim
$nvim_name = "neovim"
$nvim_spath = "$Home\Code\dotfiles\neovim"
$nvim_tpath = "$Home\AppData\Local\nvim"
linkconfig $nvim_name $nvim_spath $nvim_tpath 

# powershell
$pwsh_name = "powershell"
$pwsh_spath = "$Home\Code\dotfiles\powershell\Microsoft.Powershell_profile.ps1"
$pwsh_tpath = "C:\Users\tengy\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
linkconfig $pwsh_name $pwsh_spath $pwsh_tpath

# powershell custom modules
$pwshmod_name = "powershell modules"
$pwshmod_spath = "$Home\Code\dotfiles\powershell\Update-All"
$pwshmod_tpath = "$Home\Documents\powershell\modules\Update-All"
linkconfig $pwshmod_name $pwshmod_spath $pwshmod_tpath

# windows terminal
$wt_name = "windows terminal"
$wt_spath = "$Home\Code\dotfiles\windows_terminal\settings.json"
$wt_tpath = "$Home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
linkconfig $wt_name $wt_spath $wt_tpath

# scoop
$scoop_name = "scoop"
$scoop_spath = "$Home\Code\dotfiles\scoop\config.json"
$scoop_tpath = "$Home\.config\scoop\config.json"
linkconfig $scoop_name $scoop_spath $scoop_tpath

# alacritty
$alacritty_name = "alacritty"
$alacritty_spath = "$Home\Code\dotfiles\alacritty\alacritty.yml"
$alacritty_tpath = "$Home\AppData\Roaming\alacritty\alacritty.yml"
linkconfig $alacritty_name $alacritty_spath $alacritty_tpath

# starship
$starship_name = "starship"
$starship_spath = "$Home\Code\dotfiles\starship\starship.toml"
$starship_tpath = "$Home\.config\starship.toml"
linkconfig $starship_name $starship_spath $starship_tpath

# git
$git_name = "git"
$git_spath = "$Home\Code\dotfiles\git\.gitconfig"
$git_tpath = "$Home\.gitconfig"
linkconfig $git_name $git_spath $git_tpath

# npm
$npm_name = "npm"
$npm_spath = "$Home\Code\dotfiles\npm\.npmrc"
$npm_tpath = "$Home\.npmrc"
linkconfig $npm_name $npm_spath $npm_tpath

# conda
$conda_name = "conda"
$conda_spath = "$Home\Code\dotfiles\conda\.condarc"
$conda_tpath = "$Home\.condarc"
linkconfig $conda_name $conda_spath $conda_tpath
