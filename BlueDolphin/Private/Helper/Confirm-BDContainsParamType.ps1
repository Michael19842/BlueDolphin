function Confirm-BDContainsParamType {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        $Contains
    )

    process {
        $TypeNames = $Contains.psObject.TypeNames
        If ($TypeNames -contains 'System.Collections.Hashtable') {
            Return $true
        } ElseIf ($TypeNames -contains 'System.String') {
            Return $true
        } Else {
            Throw [System.ArgumentException]::new("Contains should be of type string or type hashtable")
        }
    }
}