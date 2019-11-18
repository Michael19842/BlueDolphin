function Get-BDEndPoint {
    [OutputType([string])]
    [CmdletBinding()]

    <#
    .SYNOPSIS
    Get an endpoint from the collection of endpoint registered in the EndPoints.json file

    .DESCRIPTION
    Return an endpoint

    .PARAMETER EndPoint
    String containing the name of the endpoint

    .PARAMETER EndPointParameters
    Optional hashtable parameter containing the value of the parameter in EndPoint

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    System.String. Add-Extension returns a string with the extension
    or file name.

    .EXAMPLE

    PS> extension -name "File"
    File.txt

    .EXAMPLE

    PS> extension -name "File" -extension "doc"
    File.doc

    .EXAMPLE

    PS> extension "File" "doc"
    File.doc

    #>
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [String] $EndPoint,
        [Parameter(Mandatory=$false)] [Hashtable] $EndPointParameters
    )
    begin {
        $EndPoints = Get-Content "$PSScriptRoot\EndPoints.json" | ConvertFrom-Json
    }
    process {
        # If there are any parameters given, then they are place in the returned string
        if($EndPointParameters) {
            $ReturnValue = $EndPoints.psObject.Properties[$EndPoint].value
            foreach ($key in $EndPointParameters.Keys) {
                $ReturnValue = $ReturnValue -replace "{{$key}}",$EndPointParameters[$key]
            }

        } else {
            $ReturnValue = $EndPoints.psObject.Properties[$EndPoint].value
        }
        if ($ReturnValue -match "{{.+}}") {
            throw [System.NullReferenceException]::new("$($Matches[0]) not supplied!")
        }
        Return $ReturnValue
    }
    end {
    }
}

