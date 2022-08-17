# Set the colors of ls
Import-Module Get-ChildItemColor

# Set  starship
Invoke-Expression (&starship init powershell)

# Autocompletion of scoop
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion" -ErrorAction SilentlyContinue

# Autocompletion of git
Import-Module PSGitCompletions

# Set ls
If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    
    Set-Alias l Get-ChildItemColor -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}


# Autocompletion of winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Set PSReadLine
Import-Module PSReadLine

# Set Vi Mode
Set-PSReadlineOption -EditMode Vi
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# Autocomplete when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Shows navigable menu of all options when hitting "Ctrl+d"
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete

# Undo when hitting "Ctrl+z"
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Auto suggestions
Set-PSReadLineOption -PredictionSource History

