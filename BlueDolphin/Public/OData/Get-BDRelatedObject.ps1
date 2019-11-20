function Get-BDRelatedObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position=0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Title, 
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $ID,
        
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit
    )
    
    begin {
        
    }
    
    process {     
        switch ($PsCmdlet.ParameterSetName) {
            "Identity" {
                $UsedIdentity = $Identity
            }
            "Object" {
                if($Title -and !$ID) {
                    $UsedIdentity =  (Get-BDObject -IsExactly @{Title = $Title}).ID 
                }
                else {
                    $UsedIdentity = $ID
                }
            }
        }
        if($UsedIdentity){
            $Rels = Get-BDRelation -IsExactly @{BlueDolphinObjectItemId = $UsedIdentity}
            $Retval = @()

            ForEach ($Rel in $rels) {
                $obj =  Get-BDObject -IsExactly @{ID = $Rel.RelatedBlueDolphinObjectItemId}

                if ($obj) {
                    $Retval += ([PSCustomObject]@{
                        RelationId =  $rel.Id
                        RelationType = $rel.Type
                        RelationName = $rel.Name
                        ObjectId = $obj.Id
                        ObjectTitle = $obj.Title
                        IsReversed =  $rel.IsRelationshipDirectionAlternative
                    })
                }
            }
            Return $RetVal
        }
    }
    
    end {
        
    }
}
