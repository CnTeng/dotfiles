function TryLink{
  [CmdletBinding()]
  Param([string]$SourcePath, [string]$TargetPath)
  [Bool]$iserror = $false
  try {
    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -ErrorAction Stop
  } catch{
    Write-Output "Error"
    $iserror = $true
  }
  if ($iserror) {
    return
  } else {
    Write-Output "Link configuration successfully."
  }
}

function LinkConfig {
  [CmdletBinding()]
  Param([string]$Name, [string]$SourcePath, [string]$TargetPath)
  if (Test-Path $TargetPath) {
    Write-Output "The configuration of $Name exists."
    [string]$ispermit = Read-Host "Do you permit to remove the existing configuration and link a new file?(y or n)"
    if ($ispermit -eq "y") {
      Remove-Item -Path $TargetPath -Recurse
      TryLink $SourcePath $TargetPath
    } else {
      Write-Output "Exit"
      return
    }
  } else {
    TryLink $SourcePath $TargetPath
    return
  }
}


# neovim
$nvimname = "neovim"
$nvimspath = "$Home\Code\dotfiles\neovim"
$nvimtpath = "$Home\AppData\Local\nvim"
LinkConfig $nvimname $nvimspath $nvimtpath 
Write-Output "`n"

# powershell
$pwshname = "powershell"
$pwshspath = "$Home\Code\dotfiles\powershell\Microsoft.Powershell_profile.ps1"
$pwshtpath = "C:\Users\tengy\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
LinkConfig $pwshname $pwshspath $pwshtpath
Write-Output "`n"

# windows terminal
$wtname = "windows terminal"
$wtspath = "$Home\Code\dotfiles\windows_terminal\settings.json"
$wttpath = "$Home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
LinkConfig $wtname $wtspath $wttpath
Write-Output "`n"
