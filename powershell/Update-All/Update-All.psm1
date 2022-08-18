function Update-All {
  Param()
  # scoop update (user)
  Write-Output "scoop update"
  scoop update *
  Write-Output "`n"

  # scoop update (global)
  Write-Output "scoop update -g"
  sudo scoop update * -g
  Write-Output "`n"

  # winget update
  Write-Output "winget update"
  winget update --all
  Write-Output "`n"

  # conda update
  Write-Output "conda update"
  conda update --all

  # wsl update (zypper)
  Write-Output "wsl update (zypper)"
  wsl --exec sudo zypper up
  wsl --exec sudo zypper dup
} 

Export-ModuleMember -Function Update-All
