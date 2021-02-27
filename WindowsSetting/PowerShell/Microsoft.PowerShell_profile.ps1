# -------------------------------------
# general
# -------------------------------------
$PowershellCore = "~\scoop\apps\pwsh\current\pwsh.exe"

# PowerShell Core7でもConsoleのデフォルトエンコーディングはsjisなので必要
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

# # git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"

$FontFamilies = [System.Drawing.FontFamily]::Families

Set-Alias ifconfig ipconfig

# Linux 形式のパスを文字列として取得。
function pwd_as_linux {
  "/$((pwd).Drive.Name.ToLowerInvariant())/$((pwd).Path.Replace('\', '/').Substring(3))"
}

Set-Alias grep rg

function gip(){
    (Invoke-RestMethod -Uri "ipinfo.io").Content
}

# vim
Set-alias v vim
Set-alias n nvim

# -------------------------------------
# Path
# -------------------------------------

function setenv($key, $value, $target) {
  if (! $target) {
    $target = "User"
  }
  if (($target -eq "Process") -Or ($target -eq "User") -Or ($target -eq "Machine")) {
    $now = [environment]::getEnvironmentVariable($key, $target)
    if ($now) {
      $tChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
      $result = $host.ui.PromptForChoice("", "Already Exists. Overwrite ?", @(
        New-Object $tChoiceDescription ("&Yes")
        New-Object $tChoiceDescription ("&No")
      ), 1)
      switch ($result) {
        0 {break}
        1 {
          Write-Host "`r`nAborted." -ForegroundColor DarkRed
          return
        }
      }
    }
    [environment]::setEnvironmentVariable($key, $value, $target)
    [environment]::setEnvironmentVariable($key, $value, "Process")
  } else {
    Write-Host "Failure ! - Invalid Target" -ForegroundColor DarkYellow
  }
}

function setpath($value, $target) {
  if (! $target) {
    $target = "User"
  }
  if (($target -eq "Process") -Or ($target -eq "User") -Or ($target -eq "Machine")) {
    $item = Convert-Path $value

    $path = [environment]::getEnvironmentVariable("PATH", $target)
    $list = $path -split ";"

    if (! $list.Contains($item)) {
      $_path = $path + ";" + $item + ";"
      $newpath = $_path -replace ";;", ";"
      [environment]::setEnvironmentVariable("PATH", $newpath, $target)

      $_path = [environment]::getEnvironmentVariable("PATH", "Process") + ";" + $item + ";"
      $newpath = $_path -replace ";;", ";"
      [environment]::setEnvironmentVariable("PATH", $newpath, "Process")
    } else {
      Write-Host "Already Exists." -ForegroundColor DarkYellow
    }
  } else {
    Write-Host "Failure ! - Invalid Target" -ForegroundColor DarkRed
  }
}

# -------------------------------------
# Manage file
# -------------------------------------
# ps v0.7以降推奨
# -execute オプションを付けないと実行されない
# https://qiita.com/AWtnb/items/2fe344fab33da6f59f0b
function Rename-Index {
    <#
        .SYNOPSIS
        連番リネーム
        .DESCRIPTION
        パイプライン経由での入力にのみ対応（出力なし）
        .PARAMETER basename
        拡張子を覗いた部分のファイル／フォルダ名
        .PARAMETER start
        連番の開始番号
        .PARAMETER pad
        インデックスの桁数
        .PARAMETER execute
        指定した場合のみリネーム
        .PARAMETER step
        連番の増分
        .PARAMETER tail
        指定時はファイル名末尾に挿入
        .EXAMPLE
        ls * | Rename-Index
    #>
    param (
        [string]$basename,
        [int]$start = 1,
        [int]$pad = 2,
        [int]$step = 1,
        [switch]$tail,
        [switch]$execute
    )

    $proc = $input | Where-Object {$_.GetType().Name -in @("FileInfo", "DirectoryInfo")}

    $shiftJIS = [System.Text.Encoding]::GetEncoding("Shift_JIS")
    if ($basename) {
        $longestName = $proc.Name | Sort-Object {$shiftJIS.GetByteCount($_)} -Descending | Select-Object -First 1
        $fill = $shiftJIS.GetByteCount($longestName) + 1
    }

    $ANSI_BlackOnGreen = "`e[42m`e[30m"
    $ANSI_BlackOnWhite = "`e[47m`e[30m"
    $ANSI_Reset = "`e[0m"
    $bgColor = ($execute)? $ANSI_BlackOnGreen : $ANSI_BlackOnWhite

    $start -= $step
    $proc | ForEach-Object {
        $start += $step
        $index = "{0:d$($pad)}" -f $start
        $fileName = $_.Name
        if ($basename) {
            Write-Host $fileName -ForegroundColor DarkGray -NoNewline
            $leftIndent = $shiftJIS.GetByteCount($fileName)
            " {0}=> " -f ("=" * ($fill - $leftIndent)) | Write-Host -NoNewline

            $nameParts = ($tail)?
                @($basename, $index, $_.Extension):
                @("", $index, ($basename + $_.Extension))
        }
        else {
            $nameParts = ($tail)?
                @($_.Basename, "_$($index)", $_.Extension):
                @("", "$($index)_", $fileName)
        }
        "{0}$($bgColor){1}$($ANSI_Reset){2}" -f $nameParts | Write-Host

        if (-not $execute) {
            return
        }

        $renamedName = $nameParts -join ""

        try {
            $_ | Rename-Item -NewName $renamedName -ErrorAction Stop
        }
        catch {
            Write-Host ("ERROR: failed to rename '{0}' to '{1}'!" -f $fileName, $renamedName) -ForegroundColor Magenta
            (Test-Path $renamedName)?
                "(same name exists in directory)":
                "(other process may opening file)" | Write-Host -ForegroundColor Magenta
        }

    }
}

# -------------------------------------
# ssh
# -------------------------------------
$env:GIT_SSH = "C:\WINDOWS\System32\OpenSSH\ssh.exe"

# -------------------------------------
# encoding
# -------------------------------------
function Get-Encoding($file_path){
    $sr = New-Object System.IO.StreamReader($file_path)
    $sr.CurrentEncoding
}

function to_UTF16-BE($file_path){
    $file = Get-Content $file_path
    $file | Set-Content -Encoding BigEndianUnicode $file_path
}

function to_UTF16-LE($file_path){
    $file = Get-Content $file_path
    $file | Set-Content -Encoding Unicode $file_path
}

function to_ASCII($file_path){
    $file = Get-Content $file_path
    $file | Set-Content -Encoding ASCII $file_path
}

function to_UTF8-nobom{
    param(
        # help
        [switch]$h,
        # recrusive
        [switch]$r,

        [string]$path
    )
    Write-Host h:$h
    Write-Host r:$r
    Write-Host path:$path

    if (-not($r)){
        $itemList = Get-ChildItem -File $path
        foreach ($item in $itemList){
            Write-Host $item.FullName
            $file = Get-Content $item.FullName
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
            [System.IO.File]::WriteAllLines($item.FullName, $file, $Utf8NoBomEncoding)
        }
    } else {
        Write-Host convert file recursive
        $itemList = Get-ChildItem -File $path -Recurse
        foreach ($item in $itemList){
            Write-Host $item.FullName
            $file = Get-Content $item.FullName
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
            [System.IO.File]::WriteAllLines($item.FullName, $file, $Utf8NoBomEncoding)
        }
    }
}


function Set-Encoding($file_path, $encoding){
    $file = Get-Content (Convert-Path $file_path)
    $file | Set-Content -Encoding $encoding (Convert-Path $file_path)
}


function to_UTF8-bom{
    param(
        # help
        [switch]$h,
        # recrusive
        [switch]$r,

        # [parameter(Position=0,ValueFromRemainingArguments=$true)]
        # [array]$arguments,

        [string]$path
    )

    if (-not($r)){
        $itemList = Get-ChildItem -File $path
        foreach ($item in $itemList){
            Write-Host $item.FullName
            Set-Encoding $item.FullName "UTF8"
        }
    } else {
        Write-Host convert file recursive
        $itemList = Get-ChildItem -File $path -Recurse
        foreach($item in $itemList){
            Write-Host $item.FullName
            Set-Encoding $item.FullName "UTF8"
        }
    }
}

# -------------------------------------
# su
# -------------------------------------

function Invoke-CommandRunAs
{
    $cd = (Get-Location).Path
    $commands = "Set-Location $cd; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias sudo Invoke-CommandRunAs

function Start-RunAs
{
    $cd = (Get-Location).Path
    $commands = "Set-Location $cd; (Get-Host).UI.RawUI.WindowTitle += `" [Administrator]`""
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias su Start-RunAs

# -------------------------------------
# git
# -------------------------------------
Set-Alias g git

function gf {
    $path = ghq list | fzf
    if ($LastExitCode -eq 0) {
        cd "$(ghq root)\$path"
    }
}

function ghg {
       ghq get --shallow $args
}


# -------------------------------------
# python
# -------------------------------------
function pp(){
    pipenv run python
}

function pj(){
    pipenv run jupyter notebook
}

# -------------------------------------
# psql
# -------------------------------------
$env:PGCLIENTENCODING = "UTF8"

# -------------------------------------
# PSReadline
# -------------------------------------
# Install-Module PSReadLine -Scope CurrentUser
Import-Module PSReadLine

# コマンド履歴から補完候補を表示
Set-PSReadLineOption -PredictionSource History

# 上矢印キーをコマンド履歴からの検索にバインド
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward

# コマンドラインの状態取得
# $line: 表示されているコマンド文字列
# $cursor: カーソル位置
$line = $null
$cursor = $null
[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

# 選択状態を取得
# なにも選択していない状態では$selectionStart = -1
$selectionStart = $null
$selectionLength = $null
[Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

# 重複した履歴を保存しない
Set-PSReadlineOption -HistoryNoDuplicates

# 履歴に残さない条件
Set-PSReadlineOption -AddToHistoryHandler {
    param ($command)
    switch -regex ($command) {
        "SKIPHISTORY" {return $false} # alt+rでの設定更新
        "^[a-z]$" {return $false} # 一文字入力
        "exit" {return $false}
    }
    return $true
}

# Ctrl + 矢印で移動するときの区切り文字
Set-PSReadLineOption -WordDelimiters ";:,.[]{}()/\|^&*-=+'`" !?@#$%&_<>「」（）『』『』［］、，。：；／"

# 括弧・引用符の入力補完
# 文字列選択時：
#   選択範囲を括弧で囲みカーソルを閉じ括弧の後ろに移動させる
# 非選択時：
#   開き括弧に対応した閉じ括弧を入力して間にカーソルを移動させる
#   一方の括弧が先に入力されていた場合は対応する括弧のみ入力する
Set-PSReadLineKeyHandler -Key "(","{","[" -BriefDescription "InsertPairedBraces" -LongDescription "Insert matching braces or wrap selection by matching braces" -ScriptBlock {
    param($key, $arg)
    $openChar = $key.KeyChar
    $closeChar = switch ($openChar) {
        <#case#> "(" { [char]")"; break }
        <#case#> "{" { [char]"}"; break }
        <#case#> "[" { [char]"]"; break }
    }

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $openChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }
    $nOpen = [regex]::Matches($line, [regex]::Escape($openChar)).Count
    $nClose = [regex]::Matches($line, [regex]::Escape($closeChar)).Count
    if ($nOpen -ne $nClose) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($openChar)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($openChar + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

# 余計な閉じ括弧を入力しない
Set-PSReadLineKeyHandler -Key ")","]","}" -BriefDescription "SmartCloseBraces" -LongDescription "Insert closing brace or skip" -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
    }
}

# コマンドを括弧で囲む
# (Get-Childitem -file).LastWriteTime とか特定のプロパティを選択したいときに
Set-PSReadLineKeyHandler -Key "alt+w" -BriefDescription "WrapLineByParenthesis" -LongDescription "Wrap the entire line and move the cursor after the closing parenthesis or wrap selected string" -ScriptBlock {
    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, "(" + $line.SubString($selectionStart, $selectionLength) + ")")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    }
}

# メソッド補完時の閉じ括弧
Remove-PSReadlineKeyHandler "tab"
Set-PSReadLineKeyHandler -Key "tab" -BriefDescription "smartNextCompletion" -LongDescription "insert closing parenthesis in forward completion of method" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext()
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[($cursor - 1)] -eq "(") {
        if ($line[$cursor] -ne ")") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(")")
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
        }
    }
}

Remove-PSReadlineKeyHandler "shift+tab"
Set-PSReadLineKeyHandler -Key "shift+tab" -BriefDescription "smartPreviousCompletion" -LongDescription "insert closing parenthesis in backward completion of method" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::TabCompletePrevious()
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[($cursor - 1)] -eq "(") {
        if ($line[$cursor] -ne ")") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(")")
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
        }
    }
}

# alt+rでプロフィール更新反映
Set-PSReadLineKeyHandler -Key "alt+r" -BriefDescription "reloadPROFILE" -LongDescription "reloadPROFILE" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('<#SKIPHISTORY#> . $PROFILE')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# -------------------------------------
# Prompt
# -------------------------------------
Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Paradox
# Set-Theme Star
# Set-Theme robbyrussell
# Set-Theme Sorin
# Set-Theme Zash
# Set-Theme Emodipt
# Set-Theme Darkblood
# Set-Theme Powerlevel10k-Lean
# Set-Theme Powerlevel9k

# Set-Theme StarY
Set-Theme ParadoxY

# -------------------------------------
# fzf
# -------------------------------------
Import-Module ZLocation
Set-PSReadLineKeyHandler -Chord 'Ctrl+]' -ScriptBlock { gf; [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() }
# cdしたことのあるフォルダの表示
Set-PSReadLineKeyHandler -Chord 'Ctrl+;' -ScriptBlock  { Invoke-FuzzyZLocation; [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() }