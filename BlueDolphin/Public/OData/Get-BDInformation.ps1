function Get-BDInformation {    
    param(
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript({Confirm-BDStartWithParamType $_})] $StartsWith,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomFilter")][ValidateNotNullOrEmpty] [String] $CustomFilter,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $_Settings.Defaults.Top,
        [Parameter(Mandatory = $false)] [int] $Skip = $_Settings.Defaults.Skip
    )

    begin {
        $_StartsWith = Convert-BDStartsWith $StartsWith
        
        $Uri = Format-BDUri -uri (Get-BDEndPoint "ODataApiDB" -EndPointParameters @{database = "Information"}) -IsExactly $IsExactly -StartsWith $_StartsWith -Top $Top -Skip $Skip -Select $Select -CustomFilter $CustomFilter -AllRecords:$AllRecords 
    }

    process {
        $ReturnValue = Invoke-BDWebRequest -uri $Uri -method get -limitedOutput:([bool]$top -and !$AllRecords ) 
    }
    
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"BlueDolphin.Object")}
        }
        Return $ReturnValue 
    }
}
