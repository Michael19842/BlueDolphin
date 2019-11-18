function Test-BDWebUri {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true)] [string] $address 
    )
    process {
        $uri = $address -as [System.URI]
        return [bool]($null -ne $uri.AbsoluteURI -and $uri.Scheme -match '[http|https]')
    }
}