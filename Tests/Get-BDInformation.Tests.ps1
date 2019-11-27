. "$PSScriptRoot/_DefaultTestStart.ps1"

Describe "Test Get-BDInformation" {
    
    InModuleScope -ModuleName "BlueDolphin" {
        Mock Invoke-BDWebRequest {return @{Test= "ok"}} -ModuleName "BlueDolphin" -Verifiable
        Mock Format-BDUri {return "https://test.conclusion.nl"} -ModuleName "BlueDolphin" -Verifiable
        
        [void](Get-BDInformation)

        It "Should call an invoke VerifiableMock" {
            Assert-VerifiableMock 
        }
    }

}