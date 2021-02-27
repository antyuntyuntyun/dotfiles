#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # path
    $sPath = "$(Get-FullPath -dir $pwd) "

    # check for elevated prompt
    $sAdmin = ""
    If (Test-Administrator) {
        $sAdmin = " $($sl.PromptSymbols.ElevatedSymbol)"
    }

    # timestamp
    $sTime = "$(Get-Date -Format HH:mm:ss)"

    # check the last command state and indicate if failed
    $sFailed = ""
    If ($lastCommandFailed) {
        $sFailed = " $($sl.PromptSymbols.FailedCommandSymbol)"
    }

    # virtualenv
    $sVenv = ""
    If (Test-VirtualEnv) {
        $sVenv = " $(Get-VirtualEnvName)"
    }

    # with
    $sWith = ""
    If ($with) {
        $sWith = " $($with.ToUpper())"
    }

    # battery
    $battery = Get-BatteryInfo

    # $rightPrompt = Write-Prompt "$sFailed$sWith$sVenv$sAdmin$sTime"
    $rightPrompt = "$battery [$sTime]  "

    #check the last command state and indicate if failed and change the colors of the arrows
    $dir = Get-FullPath -dir $pwd
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object $dir -ForegroundColor $sl.Colors.WithForegroundColor
    }else{
        $prompt += Write-Prompt -Object $dir -ForegroundColor $sl.Colors.DriveForegroundColor
    }

    # Writes the drive portion
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        # $info = "$($themeInfo.VcInfo)".Split(" ")[1].TrimStart()
        $info = (Get-VcsInfo(Get-GitStatus)).VcInfo.Split(" ")[3..9] # ローカルとブランチの差の有り無しで配列数が変わる。他のテーマ見ながらいい感じの設定を探す
        $prompt += Write-Prompt -Object " on " -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$($sl.GitSymbols.BranchSymbol+' ')" -ForegroundColor $sl.Colors.GitDefaultColor
        $prompt += Write-Prompt -Object "$($status.Branch)" -ForegroundColor $sl.Colors.GitDefaultColor
        # $prompt += Write-Prompt -Object " [$($info)]" -ForegroundColor $sl.Colors.PromptHighlightColor
        $prompt += Write-Prompt -Object " ($($info -join ' '))" -ForegroundColor $sl.Colors.PromptHighlightColor
        $filename = 'package.json'
        if (Test-Path -path $filename) {
            $prompt += Write-Prompt -Object (" via node") -ForegroundColor $sl.Colors.PromptSymbolColor
        }
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Set-CursorForRightBlockWrite -textLength $rightPrompt.Length
    $prompt += Write-Prompt $rightPrompt -ForegroundColor $sl.colors.TimestampForegroundColor

    $prompt+= Set-Newline -ForegroundColor $sl.colors.TimestampForegroundColor
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor  $sl.Colors.PromptSymbolColor
    $prompt += ' '
    $prompt

}

$sl = $global:ThemeSettings #local settings
$sl.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xE0A0)
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x279C) # →
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x276F) # >
$sl.PromptSymbols.HomeSymbol = '~'
$sl.PromptSymbols.GitDirtyIndicator =[char]::ConvertFromUtf32(10007)
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.DriveForegroundColor = [ConsoleColor]::Cyan
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
$sl.Colors.GitDefaultColor = [ConsoleColor]::Yellow
$sl.Colors.TimestampForegroundColor = [ConsoleColor]::DarkGray