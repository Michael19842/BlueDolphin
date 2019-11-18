function Connect-BlueDolphin {
<#
    .SYNOPSIS
    Creates login to the BD dolphin odata site

    .DESCRIPTION
    Creates login to the BD dolphin odata site

    .PARAMETER Tenant
    The database name of the Blue Dolphin site (found in bluedolhpin > Admin > General).

    .PARAMETER apikey
    The api key of the Blue Dolphin site (found in bluedolhpin > Admin > General).

    .EXAMPLE
    C:\PS> new-bdlogin -user <mysitedatabasename> -apikey <mysiteapikey>
    successfully setup login credentials
#>
    [CmdletBinding()]
    [OutputType([object])]
    param( 
        #Name of the database
        [Parameter(Position=0,Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $Tenant,
        # API-key as listed in the appplication
        [Parameter(Position=1,Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $ApiKey,
        [switch] $PassThru
    )
    
    process{
        $script:Session = [Session]::New($Tenant,$ApiKey)    
        if($PassThru) {Return $Session} 
    }
}
