<#
.SYNOPSIS
    Enables Boot Diagnostics for all Virtual Machines across all subscriptions in a single Azure tenant.

.DESCRIPTION
    This script connects to Azure, iterates through all subscriptions visible to the signed-in account,
    enumerates all Virtual Machines, and ensures Boot Diagnostics are enabled. If Boot Diagnostics are
    not already enabled, the script provisions (or reuses) a storage account in the VM's region and 
    enables Boot Diagnostics for that VM.

.PARAMETER None
    No input parameters are required. The script will operate on all accessible subscriptions for the 
    currently authenticated account.

.NOTES
    Author: Shannon Eldridge-Kuehn
    Version: 1.1
    Requirements:
        - PowerShell 7 recommended
        - Az PowerShell modules
        - Contributor or higher privileges on all target subscriptions
    Important:
        - Storage account names must be globally unique. The script uses a combination of "bootdiag",
          region, and part of the subscription ID to reduce collisions. Modify as needed to align with
          organizational naming standards.

.EXAMPLE
    PS C:\> .\Enable-BootDiagnostics.ps1
    Runs the script interactively. Prompts for Azure login and enables Boot Diagnostics for all VMs
    in all subscriptions accessible to the account.
#>

# Ensure Az module is loaded
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Write-Error "Az PowerShell modules are required. Install-Module Az -Scope CurrentUser"
    exit 1
}

# Connect to Azure
try {
    Connect-AzAccount -ErrorAction Stop
} catch {
    Write-Error "Failed to authenticate to Azure: $_"
    exit 1
}

# Retrieve all subscriptions
$subscriptions = Get-AzSubscription
if (-not $subscriptions) {
    Write-Warning "No subscriptions found for the current tenant."
    exit 0
}

foreach ($sub in $subscriptions) {
    Write-Host "===== Processing Subscription: $($sub.Name) =====" -ForegroundColor Cyan
    try {
        Set-AzContext -Subscription $sub.Id -ErrorAction Stop
    } catch {
        Write-Warning "Failed to set context for subscription $($sub.Name). Skipping."
        continue
    }

    # Retrieve all VMs in the subscription
    $vms = Get-AzVM
    if (-not $vms) {
        Write-Host "No VMs found in subscription $($sub.Name)." -ForegroundColor DarkGray
        continue
    }

    foreach ($vm in $vms) {
        Write-Host "Processing VM: $($vm.Name) in Resource Group: $($vm.ResourceGroupName)" -ForegroundColor Yellow

        # Skip if already enabled
        if ($vm.DiagnosticsProfile.BootDiagnostics.Enabled) {
            Write-Host "  -> Boot Diagnostics already enabled." -ForegroundColor Green
            continue
        }

        # Build storage account name
        $region = $vm.Location.Replace(" ", "").ToLower()
        $storageAcctName = ("bootdiag" + $region + $sub.Id.Substring(0,6)).ToLower()

        # Check if storage account exists
        $storageAcct = Get-AzStorageAccount -ResourceGroupName $vm.ResourceGroupName -ErrorAction SilentlyContinue |
                       Where-Object { $_.StorageAccountName -eq $storageAcctName }

        if (-not $storageAcct) {
            Write-Host "  -> Creating storage account $storageAcctName in $region" -ForegroundColor Cyan
            try {
                $storageAcct = New-AzStorageAccount -ResourceGroupName $vm.ResourceGroupName `
                                                    -Name $storageAcctName `
                                                    -SkuName Standard_LRS `
                                                    -Location $vm.Location `
                                                    -Kind StorageV2 -ErrorAction Stop
            } catch {
                Write-Warning "  -> Failed to create storage account for VM $($vm.Name). Skipping VM."
                continue
            }
        }

        $storageUri = $storageAcct.PrimaryEndpoints.Blob

        # Enable boot diagnostics
        try {
            Set-AzVMBootDiagnostic -ResourceGroupName $vm.ResourceGroupName `
                                   -VMName $vm.Name `
                                   -Enable `
                                   -StorageUri $storageUri -ErrorAction Stop

            Write-Host "  -> Boot diagnostics enabled for $($vm.Name)" -ForegroundColor Green
        } catch {
            Write-Warning "  -> Failed to enable boot diagnostics for VM $($vm.Name). Error: $_"
            continue
        }
    }
}
