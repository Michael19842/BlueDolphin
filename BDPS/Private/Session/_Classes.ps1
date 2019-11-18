

class CredentialDetails {
    [string] $Tenant
    [string] $ApiKey
    CredentialDetails($Tenant,$ApiKey){
        $this.ApiKey = $ApiKey
        $this.Tenant = $Tenant
        
    }
    [string]EncodedCredential(){
        Return [convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($this.Tenant + ":" + $this.ApiKey))
    }
    
}

class Session 
{
    [string] $Uri 
    [CredentialDetails] $User
    [bool]$isValid
    [string]$InvalidReason
    Session(){
        $this.isValid = $false
        $this.InvalidReason = "No user information provided"
    }
    Session([string]$Tenant,[string]$ApiKey) {
        $this.User = [CredentialDetails]::New($Tenant,$ApiKey) 
        $this.isValid = $true
        $this.Uri = "https://odata.bluedolphin.valueblue.nl"
    }
    Session([string] $Tenant,[string] $ApiKey,[string] $Uri) {
        $this.User = [CredentialDetails]::New($Tenant,$ApiKey) 
        $this.isValid  = $true
        $this.Uri = $Uri
    }
    
}

