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
        [hashtable] $StartsWith = @{},
        [parameter(Mandatory=$false)]
        [hashtable] $Contains = @{},
        [Alias("any")][switch] $AnyCondition
    )
    
    begin {
        $filterStart = '&$filter='
        $filter = $filterStart 
    }
    
    process {
        foreach($Key in $IsExactly.Keys){
            if($filter -ne  $filterStart){$filter += if($any){" or "} else {" and "}}
            if('System.Boolean' -in ($isExactly[$key]).psObject.Typenames) {
                $filter += "$key eq $([System.Web.HttpUtility]::UrlEncode(([string]$isExactly[$key])).toLower())"
            }
            elseif('System.Array' -in ($isExactly[$key]).psObject.Typenames) {
                $count = 0 
                foreach($value in $isExactly[$key]){
                    $count ++
                    $filter += "$key eq '$([System.Web.HttpUtility]::UrlEncode($value))'" + (&{if(!($isExactly[$key].Count -eq $count)){" or "}})
                    Write-Verbose "adding $key eq '$($value)' to filter expression"
                }
            }
            else {
                $filter += "$key eq '$([System.Web.HttpUtility]::UrlEncode($isExactly[$key]))'"
                Write-Verbose "adding $key eq '$($isExactly[$key])' to filter expression"
            }
            
           
        }

        foreach($Key in $StartsWith.Keys){
            if($filter -ne  $filterStart){$filter += if($any){" or "} else {" and "}}
            $filter += "startswith($key,'$([System.Web.HttpUtility]::UrlEncode($StartsWith[$key]))')"
            Write-Verbose "adding startswith($key,'$($StartsWith[$key])') to filter expression"
        }
        foreach($Key in $Contains.Keys){
            if($filter -ne  $filterStart){$filter += if($any){" or "} else {" and "}}
            $filter += "contains($key,'$([System.Web.HttpUtility]::UrlEncode($Contains[$key]))')"
            Write-Verbose "adding startswith($key,'$($Contains[$key])') to filter expression"
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