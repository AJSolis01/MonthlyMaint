using namespace System.Net
# Write Admin Rights


# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
param($MyFirstInputBinding, $MySecondInputBinding, $TriggerMetadata)


# Install AutomateAPI
If ($null -eq (Get-Module -ListAvailable -Name AutomateAPI)[0]) { Install-Module -Name AutomateAPI -Force } else { Import-Module -Name AutomateAPI }

# Install PoshRSJob
If ($null -eq (Get-Module -ListAvailable -Name PoshRSJob)[0]) { Install-Module -Name PoshRSJob -Force -AllowClobber } else { Import-Module -Name PoshRSJob }


Import-Module PoshRSJob 
Import-Module AutomateAPI
Connect-AutomateAPI -Server atgfw.hostedrmm.com -ClientId austins
Connect-AutomateAPI -Server atgfw.hostedrmm.com -Credential $CredentialObject -ClientID '3560d915-5624-47ba-8fd2-fbbfc3d36f91'

Connect-ControlAPI -Server https://atgfw.hostedrmm.com:8040/ -Credential $CredentialObject



Get-AutomateComputer -Online $False | Compare-AutomateControlStatus

Get-AutomateComputer -Online $True | Compare-AutomateControlStatus


Get-AutomateComputer -Online $False | Compare-AutomateControlStatus | Repair-AutomateAgent -Action Check -Confirm:$false

Get-AutomateComputer -Online $False | Compare-AutomateControlStatus | Repair-AutomateAgent -Action Restart -Confirm:$false

Get-AutomateComputer -Online $False | Compare-AutomateControlStatus | Repair-AutomateAgent -Action Update -Confirm:$false

Get-AutomateComputer -Online $False | Compare-AutomateControlStatus | Repair-AutomateAgent -Action Reinstall -Confirm:$false



# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

Pause 



