 <#
        .SYNOPSIS
        gets Objects from BlueDolphin

        .DESCRIPTION
        Returns Objects from the BlueDolphin site. Without filter it will return all Objects but filters can be set to limit the number of objects returned. 

        .PARAMETER filter
        Optional parameter to filter the results at the source.

        Strings need to be enclosed with single quotes ('')
        -filter "<property> <operator> <'string'>"
        
        Numbers and boleans shouldn't be enclosed (Note a number might be defined as a string in BlueDolphin).  
        -filter "<property> <operator> <number>"
        -filter "<property> <operator> <true/false>"
        Please note, returned boleans are displayed with a capital letter, but have to be filtered in all lowercase characters

        Filters can be set on any property, but most used will be "ID", "Title", "ArchimateType" "Definition", "Category"

        ID            = unique identifier of an object
        Title         = title of the object (unique for its Definition)
        ArchimateType = archimate type the "core" unmodified defition of the object and is the same for all BlueDolphin implementations
        Definition    = The definition of the object. This is the given definition name of the BlueDolhpin site.
        Category      = This is the Archimate layer in which the object is placed
        
        Allowed operators
        eq	   Equal	            Definition eq 'Application Component'
        ne	   Not equal	        Title ne 'App1'
        and	   Logical and          Definition eq 'Application Component' and Title ne App1
        or	   Logical or           Title eq 'App1' or Title eq 'App2'


        Wildcards in filters aren't allowed, but searchstrings can be created
        startswith (Property, 'string')    Searches objects with property beginning with 'string'
        endswith (Property, 'string')      Searches objects with property ending with 'string'
        contains (Property, 'string')      Searches objects with property containing 'string'

        See examples for more information about filters

        .EXAMPLE
        -------------------------- <EXAMPLE 1> --------------------------

        C:\PS> get-bdobject
        returns all objects

        -------------------------- <EXAMPLE 2> --------------------------

        C:\PS> get-bdobject -filter "Definition eq 'Application Component'"
        Returns all Applicationcomponent Objects in BlueDolphin

        -------------------------- <EXAMPLE 3> --------------------------

        C:\PS> get-bdobject -filter "Definition eq 'Application Component' and Title ne 'App1'"
        Returns all Application Component objects except App1
        
        -------------------------- <EXAMPLE 4> --------------------------    

        C:\PS> get-bdobject -filter "ArchimateType eq 'business_process'"
        Returns all objects of archimatetype business_process
        
        -------------------------- <EXAMPLE 5> --------------------------

        C:\PS> get-bdobject -filter "Definition eq 'Business Process' and contains(Title,'test')"
        Returns all objects of Business Process with test in the title
    #>

function Get-BDObject {    
    param(
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript({Confirm-BDContainsParamType $_})] $Contains,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomFilter")][ValidateNotNullOrEmpty] [String] $CustomFilter,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $_Settings.Defaults.Top,
        [Parameter(Mandatory = $false)] [int] $Skip = $_Settings.Defaults.Skip,
        
        [switch]$AllRecords 
    )

    begin {
        $_Contains= Convert-BDContains $Contains
        
        $Uri = Format-BDUri -uri (Get-BDEndPoint "ODataApiDB" -EndPointParameters @{database = "Objects"}) -IsExactly $IsExactly -Contains $_Contains -Top $Top -Skip $Skip -Select $Select -CustomFilter $CustomFilter -AllRecords:$AllRecords 
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
