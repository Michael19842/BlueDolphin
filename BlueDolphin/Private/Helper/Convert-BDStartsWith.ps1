function Convert-BDStartsWith {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)] $StartsWith,
        [Parameter(Mandatory = $false)] [string] $DefaultProperty = "Title"
    )

    process {
        if ($StartsWith.psObject.TypeNames -contains "System.Collections.Hashtable") {
            Return $StartsWith
        }
        elseif ($StartsWith.psObject.TypeNames -contains "System.String") {
            Return @{
                $DefaultProperty = $StartsWith
            }
        }
        else {
            Return $null
        }
    }
}