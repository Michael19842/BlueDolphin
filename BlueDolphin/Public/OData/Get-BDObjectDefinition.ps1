function Get-BDObjectDefinition {
    param(
        [Parameter(Mandatory = $false, Position = 0)] [ValidateScript({Confirm-BDContainsParamType $_})] $Contains = "",
        [Parameter(Mandatory = $false)] [hashtable] $IsExactly
        
    )

    process {
        $Objects = Get-BDObject -Contains $Contains -IsExactly $IsExactly -AllRecords
        $ReturnValue = $Objects | Group-Object {$_.Definition} 
    }
    
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"BlueDolphin.ObjectDefinition")}
        }
        Return $ReturnValue 
    }
}