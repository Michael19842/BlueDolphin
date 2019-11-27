# BlueDolphin module
This module is build as a means to interact with BlueDolphin oData REST interface.

## Disclaimer
Please be aware that this module is developed or maintained by a third party.

## Usage

### Installation
#### Using Powershell Gallery

```PowerShell
Install-Module -Name BlueDolphin
```

#### Using GIT

Download the [latest release](https://github.com/michael19842/BlueDolhin/releases/latest) and  extract the .psm1 and .psd1 files to your PowerShell profile directory (i.e. the `Modules` directory under wherever `$profile` points to in your PS console) and run:
`Import-Module BlueDolphin`

## Examples

### Example: Connecting to BlueDolpin

Connect to BlueDolphin using the API key and tenant name provided in the admin>overview page. Session state will be maintained in a module variable. Authenticationshould threfore only be required once. 

```PowerShell
$params = @{
    Tenant = "{{your tenant name}}"
    ApiKey = "{{your API Key}}"
}

Connect-BlueDolphin @params
```

### Example: Get a list of objects

```PowerShell
#Get all objects that contain "x" in the Title
Get-BDObject "x" 

#Get the top 10 object, select only the Title
Get-BDObject -top 10 -select Title

#Get all objects where the title is exactly "Campus"
Get-BDObject -IsExactly @{Title="Campus"}
```

### Example: Get relations 
```PowerShell
#Get all relations that contain "x" in the RelationDefinition
Get-BDRelation "used" 

#Get all realation where the Id is exactly "xx"
Get-BDRelation -IsExactly @{Id="xxx"}
```

### Example: Get related objects
```PowerShell
#Get a list of all object related to the object 
Get-BDRelatedObject "xxx" 

#Using the pipeline
Get-BDObject "(c)" | Get-BDRelatedObject
```

Example of output
````
Explanation                                                                        RelationDefinition RelationType
-----------                                                                        ------------------ ------------
(c) Bedrijfsactor -----------[maakt gebruik van]-------> (c) Applicatie            gebruikt door      usedby
(c) Bedrijfsactor -----------[maakt gebruik van]-------> (c) Bedrijfsproces        gebruikt door      usedby
(c) Bedrijfsactor -----------[is onderdeel van]--------> (c) Bedrijfsactor         Compositie         composition
(c) Bedrijfsproces ----------[maakt gebruik van]-------> (c) Applicatie            gebruikt door      usedby
(c) Bedrijfsproces ----------[wordt gebruikt door]-----> (c) Bedrijfsactor         gebruikt door      usedby
````
### Example: Get defenitions
```PowerShell
#Get a list of all object defenitions
Get-BDObjectDefinition 

#Get a list of all relation defenitions
Get-BDRelationDefinition 
```



## Special thanks to 
@RamblingCookieMonster: Build/Test/Deploy framework

## Scope & Contributing
Contributions are gratefully received, so please feel free to submit a pull request with additional features.
