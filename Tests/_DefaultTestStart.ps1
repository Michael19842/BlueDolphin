param()
Process{
    $ProjectRoot = Resolve-Path "$PSScriptRoot\.."
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    $ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    $ModuleName = Split-Path $ModuleRoot -Leaf
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    $ModulePsd = (Resolve-Path "$ProjectRoot\*\$ModuleName.psd1").Path
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    $ModulePsm = (Resolve-Path "$ProjectRoot\*\$ModuleName.psm1").Path
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    $DefaultsFile = Join-Path $ProjectRoot "Tests\$($ModuleName).Pester.Defaults.json"

    if (Get-Module $ModuleName){
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    }
    Import-Module $ModulePSM 
    
    $scriptBody = "using module $ModulePSM"
    $script = [ScriptBlock]::Create($scriptBody)
    . $script
}

