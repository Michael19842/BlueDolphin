@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'BlueDolphin.psm1'
    # Version number of this module.
    ModuleVersion = '0.1.10'
    # ID used to uniquely identify this module
    GUID = 'cacdad8d-42b5-483c-8265-eed990b5ae67'
    # Author of this module
    Author = 'Michael van Rooijen'
    # Company or vendor of this module
    CompanyName = 'Conclusion'
    # Copyright statement for this module
    Copyright = '(c) 2019 Michael van Rooijen (Conclusion)'
    Description = "A concept module to communicate with BlueDolphins oData Api"
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @()
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Connect-BlueDolphin','Disconnect-Bluedolphin','Test-BlueDolphinConnection','Get-BDInformation','Get-BDObject','Get-BDObjectDefinition','Get-BDRelatedObject','Get-BDRelation','Get-BDRelationDefinition')
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    # Variables to export from this module
    VariablesToExport = @()
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    # List of all files packaged with this module
    PrivateData = @{
        PSData = @{
            Tags = @("BlueDolhin","oData","BD","PSModule")
            ProjectUri = "https://github.com/Michael19842/BlueDolphin"
            HelpInfoURI = "https://github.com/Michael19842/BlueDolphin"
        }
    }
}

