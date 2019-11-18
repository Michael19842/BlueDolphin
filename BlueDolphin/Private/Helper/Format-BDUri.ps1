function Format-BDUri {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)] $uri,
        [Parameter(Mandatory = $false)] [hashtable] $IsExactly,
        [Parameter(Mandatory = $false)] [hashtable] $StartsWith,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top,
        [Parameter(Mandatory = $false)] [int] $Skip,
        [Parameter(Mandatory = $false)] [string] $CustomFilter,

        [switch] $AllRecords
    )

    process {
        #build filter
        if($CustomFilter) {
            $_Filter = '&$filter=' + $CustomFilter
        } else {
            if($IsExactly -or $StartsWith){
                $_Filter = New-BDFilter -IsExactly $IsExactly -StartsWith $StartsWith
            }
        }
        #build select
        if($Select){
            $_Select = '&$select=' + [System.Web.HttpUtility]::UrlEncode($Select -join ",")
        }
        #add top
        if(!$AllRecords){
            if($Top){
                $_Top = '&$top=' + "$Top"
            }
        } else {
            $_Top = '&$top=' +  999
        }
        #add skip
        if($Skip){
            $_Skip = '&$skip=' + "$skip"
        }
    }
    end {
        $uriParams = "$_Filter$_Select$_Top$_Skip"
        Return ("$Uri" + ($uriParams -replace '^&','?' ))
    }
}