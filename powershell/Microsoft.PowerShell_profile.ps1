<# Prompt #>
Invoke-Expression (&starship init powershell)

# PSReadLine
Import-Module PSReadLine
# PredictionSource
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Update-All modules
Import-Module Update-All
Set-Alias upall Update-All

<# Command #>
# Colors of ls
Import-Module Get-ChildItemColor
# Ls
If (-Not (Test-Path Variable:PSise)) {
  # Only run this in the console and not in the ISE
  Import-Module Get-ChildItemColor
    
  Set-Alias l Get-ChildItemColor -option AllScope
  Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}

# Zoxide
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
  })


<# Aurocompletion #>
# git
Enable-PowerType
# scoop
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
# winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}


<# Keymaps #>
# Undo
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# Autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function Complete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key "Ctrl+k" -Function PreviousHistory
Set-PSReadlineKeyHandler -Key "Ctrl+j" -Function NextHistory
# Shows navigable menu of all options
Set-PSReadLineKeyHandler -Key "Ctrl+s" -Function MenuComplete
# AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Key "Ctrl+l" -Function ForwardWord
# AcceptSuggestion
Set-PSReadLineKeyHandler -Key "Ctrl+L" -Function AcceptSuggestion
