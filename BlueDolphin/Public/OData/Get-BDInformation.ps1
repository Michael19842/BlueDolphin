function Get-BDInformation {    
    param(
    )

    begin {
        $Uri = Format-BDUri -uri (Get-BDEndPoint "ODataApiDB" -EndPointParameters @{database = "Information"})
    }

    process {
        $ReturnValue = Invoke-BDWebRequest -uri $Uri -method get -limitedOutput:([bool]$top -and !$AllRecords ) 
    }
    
    end {
        $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"BlueDolphin.Information")}
        Return $ReturnValue 
    }
}
