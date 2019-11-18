$EventText = @{
    Succes = "{white}[{green}V{white}]"
    Failed = "{white}[{red}X{white}]"
    Error = "{white}[{red}!{white}]"
    Prompt = "{blue}BlueDolpin:"
}
function Write-Color {
    Param (
        [string] 
        $text = $(Write-Error "You must specify some text"),
        [switch] 
        $NoNewLine = $false
    )
    Begin {
        $startColor = $host.UI.RawUI.ForegroundColor;
    }
    Process {
        $text.Split( [char]"{", [char]"}" ) | ForEach-Object { $i = 0; } {
            if ($i % 2 -eq 0) {
                Write-Host $_ -NoNewline;
            } else {
                if ($_ -in [enum]::GetNames("ConsoleColor")) {
                    $host.UI.RawUI.ForegroundColor = ($_ -as [System.ConsoleColor]);
                }
            }
            $i++;
        }
    }
    End {
        if (!$NoNewLine) {Write-Host;}
        $host.UI.RawUI.ForegroundColor = $startColor;
    }
}

