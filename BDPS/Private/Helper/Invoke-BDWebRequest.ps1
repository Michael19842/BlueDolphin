
function Invoke-BDWebRequest {
    [CmdletBinding(SupportsShouldProcess)]
    
    param (
        [Parameter(Mandatory = $true)] [ValidateSet('get', 'set', 'patch', 'post', 'delete')] $method, 
        [Parameter(Mandatory = $true)] [ValidateScript ( { Test-BDWebUri -address $_ })]$uri,
        [Parameter(Mandatory = $false )] [string] $body,
        [Parameter(Mandatory = $false )] $contentType = "application/json",
        [switch] $limitedOutput,
        [switch] $Raw,
        [switch] $Force
    )
    
    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }
    
    process {
        Write-Verbose "method: $method"
        Write-Verbose "contentType: $contentType"

        if ($body) { Write-Verbose "body:$(ConvertTo-Json $body)" }

        if ($Force -or $PSCmdlet.ShouldProcess("$uri")) {
            $response = try {
                if ($body) {
                    (Invoke-WebRequest -Method $method -Uri $uri -ContentType $contentType -Headers @{Authorization = "Basic $($Session.User.EncodedCredential())" } -Body $body -UseBasicParsing -ErrorAction Stop)
                }
                else {
                    (Invoke-WebRequest -Method $method -Uri $uri -ContentType $contentType -Headers @{Authorization = "Basic $($Session.User.EncodedCredential())" } -UseBasicParsing -ErrorAction Stop)
                }
            }
            catch [System.Net.WebException] {
                Write-Verbose "An exception was caught: $($_.Exception.Message)"
                @{
                    BaseResponse = $_.Exception.Response
                    Exception    = $_
                }
            }

            Switch ($response.BaseResponse.StatusCode.Value__) {
                <#
                    200 OK
                    201 Created
                    202 Accepted
                    203 Non-Authoritative Information
                    204 No Content
                #>
                { $_ -in @(200, 201, 202, 203, 204) } {
                    if ($response.Content) {
                        $responseContent = ConvertFrom-Json $response.Content

                        if ($responseContent."@odata.context" -match '\$entity$') {
                            if (!$raw) { $responseContent.PSObject.properties.remove('@odata.context') }
                            return $responseContent
                        }
                        else {
                            $list = @()
                            $list += $responseContent.value
                            if (!$limitedOutput) {
                                if ($responseContent."@odata.nextLink") {
                                    $list += (Get-MSGObject $responseContent."@odata.nextLink")
                                }
                            }
                            return $list
                        }
                    }
                    else {
                        return @{ }
                    }
                }
                { $_ -in @(400) } {
                    $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
                    throw [System.InvalidOperationException]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
                }
                { $_ -in @(403) } {
                    $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
                    throw [System.UnauthorizedAccessException]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
                }
                { $_ -in @(404) } {
                    $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
                    throw [System.Exception]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
                }
                default {
                    throw "unexpected error $($response.BaseResponse.StatusCode.Value__)"
                }
            }
        }
    }
    
    end {
        
    }
}
        