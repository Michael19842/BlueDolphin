function Confirm-BDStartWithParamType {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        $StartsWith
    )

    process {
        $TypeNames = $StartsWith.psObject.TypeNames
        If ($TypeNames -contains 'System.Collections.Hashtable') {
            Return $true
        } ElseIf ($TypeNames -contains 'System.String') {
            Return $true
        } Else {
            Throw [System.ArgumentException]::new("StartsWith should be of type string or type hashtable")
        }
    }
}