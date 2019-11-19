function Convert-BDContains {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)] $Contains,
        [Parameter(Mandatory = $false)] [string] $DefaultProperty = "Title"
    )

    process {
        if ($Contains.psObject.TypeNames -contains "System.Collections.Hashtable") {
            Return $Contains
        }
        elseif ($Contains.psObject.TypeNames -contains "System.String") {
            Return @{
                $DefaultProperty = $Contains
            }
        }
        else {
            Return $null
        }
    }
}