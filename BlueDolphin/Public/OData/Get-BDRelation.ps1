function Get-BDRelation {    
    param(
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript({Confirm-BDContainsParamType $_})] $Contains,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomFilter")][ValidateNotNullOrEmpty] [String] $CustomFilter,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $_Settings.Defaults.Top,
        [Parameter(Mandatory = $false)] [int] $Skip = $_Settings.Defaults.Skip,
        [switch] $AllRecords,
        [Alias('any')][switch] $AnyCondition
    )

    begin {
        $_Contains = Convert-BDContains $Contains
        
        $Uri = Format-BDUri -uri (Get-BDEndPoint "ODataApiDB" -EndPointParameters @{database = "Relations"}) -IsExactly $IsExactly -Contains $Contains -Top $Top -Skip $Skip -Select $Select -CustomFilter $CustomFilter -AllRecords:$AllRecords -AnyCondition:$AnyCondition
    }

    process {
        $ReturnValue = Invoke-BDWebRequest -uri $Uri -method get -limitedOutput:([bool]$top -and !$AllRecords ) 
    }
    
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"BlueDolphin.Relation")}
        }
        Return $ReturnValue 
    }
}
