function Update-All {
  Param()
  # scoop update (user)
  Write-Host "scoop update *" -ForegroundColor Blue
  scoop update *
  Write-Host "`n"

  # scoop update (global)
  Write-Host "sudo scoop update -g" -ForegroundColor Blue
  sudo scoop update * -g
  Write-Host "`n"

  # winget update
  Write-Host "winget update -all" -ForegroundColor Blue
  winget update --all
  Write-Host "`n"

  # powershell Update-Module
  Write-Host "Update-Module" -ForegroundColor Blue
  Update-Module
  Write-Host "`n"

  # conda update
  Write-Host "conda update -all" -ForegroundColor Blue
  conda update --all

  # wsl update (zypper)
  Write-Host "wsl update" -ForegroundColor Blue
  wsl --exec sudo apt update
  wsl --exec sudo apt upgrade
} 

Export-ModuleMember -Function Update-All
