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



## Special thanks to 
@RamblingCookieMonster: Build/Test/Deploy framework

## Scope & Contributing
Contributions are gratefully received, so please feel free to submit a pull request with additional features.
