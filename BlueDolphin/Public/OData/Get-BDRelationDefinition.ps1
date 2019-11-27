function Get-BDRelationDefinition {
    param(
        [Parameter(Mandatory = $false, Position = 0)] [ValidateScript({Confirm-BDContainsParamType $_})] $Contains = "",
        [Parameter(Mandatory = $false)] [hashtable] $IsExactly
        
    )

    process {
        $Objects = Get-BDRelation -Contains $Contains -IsExactly $IsExactly -AllRecords
        $ReturnValue = $Objects | Group-Object {$_.RelationshipDefinitionName} 
    }
    
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"BlueDolphin.RelationDefinition")}
        }
        Return $ReturnValue 
    }
}