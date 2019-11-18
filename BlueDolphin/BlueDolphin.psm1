#Requires -Version 5.0
[cmdletbinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignment','')]
param(
    [Parameter(Mandatory = $false,Position =0)][ValidateSet("Test","Production")][String] $Mode = "Production"
)

Write-Verbose $PSScriptRoot

Write-Verbose 'Import everything in sub folders folder'
foreach($Folder in @('Private', 'Public'))
{
    $Root = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if(Test-Path -Path $Root)
    {
        Write-Verbose "processing folder $Root"
        $Files = Get-ChildItem -Path $Root -Filter *.ps1 -Recurse

        # dot source each file
        $Files | Where-Object{ $_.name -NotLike '*.Tests.ps1' } |
            ForEach-Object {
                Write-Verbose $_.basename
                . $PSItem.FullName
            }
        }
}

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
$Local:Session = [Session]::new()
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
$Local:DefaultRecordLimit = 100

Update-FormatData -PrependPath $PSScriptRoot\BlueDolphin.Format.ps1xml

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse).BaseName
if($Mode -eq "Test")    {
    Write-Verbose "Imported Private Functions in test mode"
    Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse).BaseName
}

