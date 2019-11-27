function Format-BDUri {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)] $uri,
        [Parameter(Mandatory = $false)] [hashtable] $IsExactly,
        [Parameter(Mandatory = $false)] [hashtable] $StartsWith,
        [Parameter(Mandatory = $false)] [hashtable] $Contains,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top,
        [Parameter(Mandatory = $false)] [int] $Skip,
        [Parameter(Mandatory = $false)] [string] $CustomFilter,

        [Alias("all")][switch] $AllRecords,
        [Alias("any")][switch] $AnyCondition
    )

    process {
        #build filter
        if($CustomFilter) {
            $_Filter = '&$filter=' + $CustomFilter
        } else {
            if($IsExactly -or $StartsWith -or $Contains){
                $_Filter = New-BDFilter -IsExactly $IsExactly -StartsWith $StartsWith -Contains $Contains -anyCondition:$anyCondition
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