function New-BDFilter { 
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')] 
    <#
    .SYNOPSIS
    Generate a filter statement based on MatchExact and StartsWith params 
    .DESCRIPTION
    All expressions are joined with an and statement

    .PARAMETER IsExactly

    .PARAMETER StartsWith

    .INPUTS
    N/A
    .OUTPUTS
    <string> containing the filter statement
    .EXAMPLE
    New-MSGFilter -IsExactly $IsExactly -StartsWith $StartsWith

    .EXAMPLE
    New-MSGFilter -IsExactly $IsExactly 
    .EXAMPLE
    New-MSGFilter -StartsWith $StartsWith

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory=$false)]
        [hashtable] $IsExactly = @{},
        [parameter(Mandatory=$false)]
        [hashtable] $StartsWith = @{}
    )
    
    begin {
        $filterStart = '&$filter='
        $filter = $filterStart 
    }
    
    process {
        foreach($Key in $IsExactly.Keys){
            if($filter -ne  $filterStart){$filter += " and "}
            if('System.Boolean' -in ($isExactly[$key]).psObject.Typenames) {
                $filter += "$key eq $([System.Web.HttpUtility]::UrlEncode(([string]$isExactly[$key])).toLower())"
            }
            else {
                $filter += "$key eq '$([System.Web.HttpUtility]::UrlEncode($isExactly[$key]))'"
            }
            
            Write-Verbose "adding $key eq '$($isExactly[$key])' to filter expression"
        }

        foreach($Key in $StartsWith.Keys){
            if($filter -ne  $filterStart){$filter += " and "}
            $filter += "startswith($key,'$([System.Web.HttpUtility]::UrlEncode($StartsWith[$key]))')"
            Write-Verbose "adding startswith($key,'$($StartsWith[$key])') to filter expression"
        }
    }
    
    end {
        if($filter -ne  $filterStart){
            return $filter
        } else {
            return ""
        }      
    }
}