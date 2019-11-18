function Disconnect-BlueDolhin {
    <#
    .SYNOPSIS

    removes login information for this session.

    .EXAMPLE

    C:\PS> remove-bdlogin
    Successfully removed login information
    #>
    [CmdletBinding()]
    param(
        [switch] $PassThru
    )
    process{
        Write-Verbose "Resetting session"
        $Local:Session = [session]::new()
        if ($PassThru) {Return $Session}
    }
}