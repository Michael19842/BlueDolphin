# BlueDolphin module
This module is build as a means to interact with BlueDolphin oData Rest interface

## Usage
###Using Powershell Gallery


```PowerShell
Install-Module -Name BlueDolphin
```

### Using GIT

Download the [latest release](https://github.com/michael19842/BlueDolhin/releases/latest) and  extract the .psm1 and .psd1 files to your PowerShell profile directory (i.e. the `Modules` directory under wherever `$profile` points to in your PS console) and run:
`Import-Module BlueDolphin`

### Example: Connecting to BlueDolpin

Connect to BlueDolphin using the API key and tenant name provided in the admin>overview page. Session state will be maintained in a module variable. Logging in should threfore only be required once. 

```PowerShell
$params = @{
    Tenant = "{{your tenant name}}"
    ApiKey = "{{your API Key}}"
}

Connect-BlueDolphin @params
```

## Special thanks to 
@RamblingCookieMonster: Build/Test/Deploy framework

## Scope & Contributing
Contributions are gratefully received, so please feel free to submit a pull request with additional features.
