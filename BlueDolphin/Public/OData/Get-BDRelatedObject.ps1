function Get-BDRelatedObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position=0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Title, 
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $ID,
        
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit,
        [Alias("any")][switch] $AnyCondition
    )
    
    begin {
        $MaxRecordsInCall = 10 #Or it 'll glitch 
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
            $Relations = Get-BDRelation -IsExactly @{BlueDolphinObjectItemId = $UsedIdentity}
            $ThisObject = Get-BDObject -IsExactly @{ID = $UsedIdentity}
            $Retval = @()
            $isExactly = @{ID = @()}
            
            $Objects = @()

            #Get the Objects
            ForEach ($Relation in $Relations) {
                $RecordsInCalls +=1
                $isExactly.ID += $Relation.RelatedBlueDolphinObjectItemId  

                #If there are x object id in queue or this is the last object, get the objects
                if($RecordsInCalls -eq $MaxRecordsInCall -or $Relation -eq $Relations[-1]) {
                    $Objects += Get-BDObject -IsExactly $isExactly 
                    $RecordsInCalls = 0
                    $isExactly = @{ID = @()}
                }
            }


            #Attach the relation and object details
            ForEach ($Relation in $Relations) {
                $Object = [PSCustomObject]@{}
                $Object = ($Objects | ? ID -eq $Relation.RelatedBlueDolphinObjectItemId)[0].PSObject.Copy()
                $Object | Add-Member -Name "Direction" -MemberType NoteProperty -Value (IIf $Relation.IsRelationshipDirectionAlternative "=>" "<=")
                $Object | Add-Member -Name "Relation" -MemberType NoteProperty -Value $Relation  
                $Object | Add-Member -Name "RelatedObject" -MemberType NoteProperty -Value $ThisObject 
                [void]$Object.PSObject.TypeNames.Remove("BlueDolphin.Object")
                [void]$Object.PSObject.TypeNames.Insert(0,"BlueDolphin.RelatedObject")
                $Retval += $Object
            }

            Return $RetVal
        }
    }
    
    end {
        
    }
}
