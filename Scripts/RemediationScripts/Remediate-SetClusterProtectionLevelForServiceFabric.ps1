﻿<###
# Overview:
    This script is used to set the Cluster Protection Level to Ecrypt and Sign for Service Fabric in a Subscription.

# Control ID:
    Azure_ServiceFabric_DP_Set_Property_ClusterProtectionLevel

# Display Name:
    Cluster Protection Level must be EncryptandSign.

# Prerequisites:
    
    Owner or higher priviliged role on the Service Fabric(s) is required for remediation.

# Steps performed by the script:
    To remediate:
        1. Validating and installing the modules required to run the script and validating the user.
        2. Get the list of Service Fabric(s) in a Subscription that have Cluster Protection Level value other than EncryptandSign or Cluster Protection level is not enable.
        3. Back up details of Service Fabric(s) that are to be remediated.
        4. Set the Cluster Protection Level to Ecrypt and Sign on Service Fabric(s) in the Subscription.

    To roll back:
        1. Validate and install the modules required to run the script and validating the user.
        2. Get the list of Service Fabric(s) in a Subscription, the changes made to which previously, are to be rolled back.
        3. Set the Cluster Protection Level to Ecrypt and Sign on Service Fabric(s) in the Subscription.

# Instructions to execute the script:
    To remediate:
        1. Download the script.
        2. Load the script in a PowerShell session. Refer https://aka.ms/AzTS-docs/RemediationscriptExcSteps to know more about loading the script.
        3. Execute the script to set the Cluster Protection Level to Ecrypt and Sign on Service Fabric(s) in the Subscription. Refer `Examples`, below.

    To roll back:
        1. Download the script.
        2. Load the script in a PowerShell session. Refer https://aka.ms/AzTS-docs/RemediationscriptExcSteps to know more about loading the script.
        3. Execute the script to set the Cluster Protection Level to Ecrypt and Sign on Service Fabric(s) in the Subscription. Refer `Examples`, below.

# Examples:
    To remediate:
        1. To review the Service Fabric(s) in a Subscription that will be remediated:
    
           Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -DryRun

        2. Set the Cluster Protection level to Encrypt and Sign on Service Fabric(s) in the Subscription:
       
           Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck

        3. Set the Cluster Protection level to Encrypt and Sign on Service Fabric(s) in the Subscription, from a previously taken snapshot:
       
           Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -FilePath C:\AzTS\Subscriptions\00000000-xxxx-0000-xxxx-000000000000\202109131040\SetClusterProtectionLevelforServiceFabric\ServiceFabricDetailsBackUp.csv

        To know more about the options supported by the remediation command, execute:
        
        Get-Help Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -Detailed

    To roll back:
        1. Set the Cluster Protection level to Previous Value on Service Fabric(s) in the Subscription, from a previously taken snapshot:
           Set-ClusterProtectionLeveltoPreviousValueforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -FilePath C:\AzTS\Subscriptions\00000000-xxxx-0000-xxxx-000000000000\202109131040\SetClusterProtectionLevelforServiceFabric\RemediatedServiceFabric.csv
       
        To know more about the options supported by the roll back command, execute:
        
        Get-Help Set-ClusterProtectionLeveltoPreviousValueforServiceFabric -Detailed        
###>


function Setup-Prerequisites
{
    <#
        .SYNOPSIS
        Checks if the prerequisites are met, else, sets them up.

        .DESCRIPTION
        Checks if the prerequisites are met, else, sets them up.
        Includes installing any required Azure modules.

        .INPUTS
        None. You cannot pipe objects to Setup-Prerequisites.

        .OUTPUTS
        None. Setup-Prerequisites does not return anything that can be piped and used as an input to another command.

        .EXAMPLE
        PS> Setup-Prerequisites

        .LINK
        None
    #>

    # List of required modules
    $requiredModules = @("Az.Accounts", "Az.ServiceFabric")

    Write-Host "Required modules: $($requiredModules -join ', ')" -ForegroundColor $([Constants]::MessageType.Info)
    Write-Host "Checking if the required modules are present..."

    $availableModules = $(Get-Module -ListAvailable $requiredModules -ErrorAction Stop)

    # Check if the required modules are installed.
    $requiredModules | ForEach-Object {
        if ($availableModules.Name -notcontains $_)
        {
            Write-Host "Installing [$($_)] module..." -ForegroundColor $([Constants]::MessageType.Info)
            Install-Module -Name $_ -Scope CurrentUser -Repository 'PSGallery' -ErrorAction Stop
             Write-Host "[$($_)] module is installed." -ForegroundColor $([Constants]::MessageType.Update)
        }
        else
        {
            Write-Host "[$($_)] module is present." -ForegroundColor $([Constants]::MessageType.Update)
        }
    }
}


function Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric
{
    <#
        .SYNOPSIS
        Remediates 'Azure_ServiceFabric_DP_Set_Property_ClusterProtectionLevel' Control.

        .DESCRIPTION
        Remediates 'Azure_ServiceFabric_DP_Set_Property_ClusterProtectionLevel' Control.
        Set ClusterProtectionLevel as EncryptandSign in Service Fabric(s) in the Subscription. 
        
        .PARAMETER SubscriptionId
        Specifies the ID of the Subscription to be remediated.
        
        .PARAMETER Force
        Specifies a forceful remediation without any prompts.
        
        .Parameter PerformPreReqCheck
        Specifies validation of prerequisites for the command.
        
        .PARAMETER DryRun
        Specifies a dry run of the actual remediation.
        
        .PARAMETER FilePath
        Specifies the path to the file to be used as input for the remediation.

        .INPUTS
        None. You cannot pipe objects to Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric.

        .OUTPUTS
        None. Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric does not return anything that can be piped and used as an input to another command.

        .EXAMPLE
        PS> Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -DryRun

        .EXAMPLE
        PS> Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck

        .EXAMPLE
        PS> Set-ClusterProtectionLeveltoEncryptandSignforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -FilePath C:\AzTS\Subscriptions\00000000-xxxx-0000-xxxx-000000000000\202109131040\SetServiceFabricWithClusterProtectionLevel\ServiceFabricDetailsBackUp.csv

        .LINK
        None
    #>

    param (
        [String]
        [Parameter(ParameterSetName = "DryRun", Mandatory = $true, HelpMessage="Specifies the ID of the Subscription to be remediated")]
        [Parameter(ParameterSetName = "WetRun", Mandatory = $true, HelpMessage="Specifies the ID of the Subscription to be remediated")]
        $SubscriptionId,

        [Switch]
        [Parameter(ParameterSetName = "WetRun", HelpMessage="Specifies a forceful remediation without any prompts")]
        $Force,

        [Switch]
        [Parameter(ParameterSetName = "DryRun", HelpMessage="Specifies validation of prerequisites for the command")]
        [Parameter(ParameterSetName = "WetRun", HelpMessage="Specifies validation of prerequisites for the command")]
        $PerformPreReqCheck,

        [Switch]
        [Parameter(ParameterSetName = "DryRun", Mandatory = $true, HelpMessage="Specifies a dry run of the actual remediation")]
        $DryRun,

        [String]
        [Parameter(ParameterSetName = "WetRun", HelpMessage="Specifies the path to the file to be used as input for the remediation")]
        $FilePath
    )

    Write-Host $([Constants]::DoubleDashLine)

    if ($PerformPreReqCheck)
    {
        try
        {
            Write-Host "[Step 1 of 4] Validating and installing the modules required to run the script and validating the user..."
            Write-Host $([Constants]::SingleDashLine)
            Write-Host "Setting up prerequisites..."
            Setup-Prerequisites
        }
        catch
        {
            Write-Host "Error occurred while setting up prerequisites. Error: $($_)" -ForegroundColor $([Constants]::MessageType.Error)
            break
        }
    }
    else
    {
        Write-Host "[Step 1 of 4] Validating the user... "
    }

    # Connect to Azure account
    $context = Get-AzContext

    if ([String]::IsNullOrWhiteSpace($context))
    {
        Write-Host $([Constants]::SingleDashLine)
        Write-Host "Connecting to Azure account..."
        Connect-AzAccount -Subscription $SubscriptionId -ErrorAction Stop | Out-Null
        Write-Host "Connected to Azure account." -ForegroundColor $([Constants]::MessageType.Update)
    }
     else
    {
        # Setting up context for the current Subscription.
        $context = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop
    }

   
    
    Write-Host $([Constants]::SingleDashLine)
    Write-Host "Subscription Name: [$($context.Subscription.Name)]"
    Write-Host "Subscription ID: [$($context.Subscription.SubscriptionId)]"
    Write-Host "Account Name: [$($context.Account.Id)]"
    Write-Host "Account Type: [$($context.Account.Type)]"
    Write-Host $([Constants]::SingleDashLine)
	    
    Write-Host "***  To change cluster protection level on Service Fabric in a Subscription, Contributor or higher privileged role assignment on the Service fabric(s) is required.***" -ForegroundColor $([Constants]::MessageType.Info)
   
    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "[Step 2 of 4] Preparing to fetch all Service Fabric(s)..."
    Write-Host $([Constants]::SingleDashLine)
    
    # list to store Container details.
    $ServiceFabricDetails = @()

    # No file path provided as input to the script. Fetch all Service Fabric(s) in the Subscription.
    if ([String]::IsNullOrWhiteSpace($FilePath))
    {
        Write-Host "Fetching all Service Fabric(s) in Subscription: $($context.Subscription.SubscriptionId)" -ForegroundColor $([Constants]::MessageType.Info)

        # Get all Service Fabric(s) in a Subscription
        $ServiceFabricDetails =  Get-AzServiceFabricCluster -ErrorAction Stop

        # Seperating required properties
        $ServiceFabricDetails = $ServiceFabricDetails | Select-Object @{N='ResourceId';E={$_.Id}},
                                                                          @{N='ResourceGroupName';E={$_.Id.Split("/")[4]}},
                                                                          @{N='ResourceName';E={$_.Name}},
                                                                          @{N='IsClusterProtectionLevelExist';E={$_.FabricSettings.Parameters.Name -Contains 'ClusterProtectionLevel'}},
                                                                          @{N='ClusterProtectionLevelValue';E={if(($_.FabricSettings.Parameters.Name -Contains 'ClusterProtectionLevel') -eq $true)
                                                                          { 
                                                                                $param = $_.FabricSettings | Where-Object {$_.Parameters.Name -eq 'ClusterProtectionLevel'}
                                                                                $param.Parameters.Value
                                                                          }                                                                          
                                                                          }},
                                                                          @{N='NodeVMCount';E={$_.NodeTypes.VmInstanceCount}}

    }
    else
    {
        if (-not (Test-Path -Path $FilePath))
        {
            Write-Host "ERROR: Input file - $($FilePath) not found. Exiting..." -ForegroundColor $([Constants]::MessageType.Error)
            break
        }

        Write-Host "Fetching all Service Fabric(s) from [$($FilePath)]..." 

        $ServiceFabricResources = Import-Csv -LiteralPath $FilePath
        $validServiceFabricResources = $ServiceFabricResources| Where-Object { ![String]::IsNullOrWhiteSpace($_.ResourceId) }
        $validServiceFabricResources| ForEach-Object {
            $resourceId = $_.ResourceId

            try
            {                
                $ServiceFabricResource =  Get-AzServiceFabricCluster -ResourceGroupName $_.ResourceGroupName -Name $_.ResourceName -ErrorAction SilentlyContinue
            
                $ServiceFabricDetails += $ServiceFabricResource  | Select-Object @{N='ResourceId';E={$_.Id}},
                                                                          @{N='ResourceGroupName';E={$_.Id.Split("/")[4]}},
                                                                          @{N='ResourceName';E={$_.Name}}, 
                                                                          @{N='IsClusterProtectionLevelExist';E={$_.FabricSettings.Parameters.Name -Contains 'ClusterProtectionLevel'}},
                                                                          @{N='ClusterProtectionLevelValue';E={if(($_.FabricSettings.Parameters.Name -Contains 'ClusterProtectionLevel') -eq $true)
                                                                          { 
                                                                                $param = $_.FabricSettings | Where-Object {$_.Parameters.Name -eq 'ClusterProtectionLevel'}
                                                                                $param.Parameters.Value
                                                                          }                                                                          
                                                                          }},
                                                                          @{N='NodeVMCount';E={$_.NodeTypes.VmInstanceCount}}
            }
            catch
            {
                Write-Host "Error fetching Service Fabric(s) resource: Resource ID - $($resourceId). Error: $($_)" -ForegroundColor $([Constants]::MessageType.Error)
            }
        }
    }

    $totalServiceFabric = ($ServiceFabricDetails| Measure-Object).Count

    if ($totalServiceFabric -eq 0)
    {
        Write-Host "No Service Fabric(s) found. Exiting..." -ForegroundColor $([Constants]::MessageType.Warning)
        break
    }
  
    Write-Host "Found [$($totalServiceFabric)] Service Fabric(s)." -ForegroundColor $([Constants]::MessageType.Update)
                                                                          
    Write-Host $([Constants]::SingleDashLine)
    
    # list for storing Service Fabric(s) for which Cluster Protection level is not as Encrypt and Sign.
    $ServiceFabricWithoutEncryptandSign = @()

    Write-Host "Separating Service Fabric(s) for which Cluster Protection level is not as Encrypt and Sign or no Cluster Protection level is not enabled..."

    $ServiceFabricDetails | ForEach-Object {
        $ServiceFabric = $_        
            if($_.IsClusterProtectionLevelExist -eq $false -or $_.ClusterProtectionLevelValue -ne 'EncryptAndSign')
            {
                $ServiceFabricWithoutEncryptandSign += $ServiceFabric
            }
    }
   
    $totalServiceFabricWithoutEncryptandSign  = ($ServiceFabricWithoutEncryptandSign | Measure-Object).Count

    if ($totalServiceFabricWithoutEncryptandSign  -eq 0)
    {
        Write-Host "No Service Fabric(s) found with Cluster Protection level is other than Encrypt and Sign or Cluster Protection level is not enabled.. Exiting..." -ForegroundColor $([Constants]::MessageType.Warning)
        break
    }

    Write-Host "Found [$($totalServiceFabricWithoutEncryptandSign)] Service Fabric(s) for which Cluster Protection level is other than Encrypt and Sign or Cluster Protection level is not enabled ." -ForegroundColor $([Constants]::MessageType.Update)

    $colsProperty = @{Expression={$_.ResourceName};Label="ResourceName";Width=30;Alignment="left"},
                    @{Expression={$_.ResourceGroupName};Label="ResourceGroupName";Width=30;Alignment="left"},
                    @{Expression={$_.ResourceId};Label="ResourceId";Width=100;Alignment="left"},
                    @{Expression={$_.IsClusterProtectionLevelExist};Label="IsClusterProtectionLevelExist";Width=100;Alignment="left"},
                    @{Expression={$_.ClusterProtectionLevelValue};Label="Cluster Protection Level Value";Width=100;Alignment="left"},
                    @{Expression={$_.NodeVMCount};Label="Node VM Instance Count";Width=100;Alignment="left"}

        
    $ServiceFabricWithoutEncryptandSign | Format-Table -Property $colsProperty -Wrap

    # Back up snapshots to `%LocalApplicationData%'.
    $backupFolderPath = "$([Environment]::GetFolderPath('LocalApplicationData'))\AzTS\Remediation\Subscriptions\$($context.Subscription.SubscriptionId.replace('-','_'))\$($(Get-Date).ToString('yyyyMMddhhmm'))\SetServiceFabricWithClusterProtectionLevel"

    if (-not (Test-Path -Path $backupFolderPath))
    {
        New-Item -ItemType Directory -Path $backupFolderPath | Out-Null
    }
 
    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "[Step 3 of 4] Backing up Service Fabric(s) details..."
    Write-Host $([Constants]::SingleDashLine)

    if ([String]::IsNullOrWhiteSpace($FilePath))
    {
        
    
        # Backing up Service Fabric(s) details.
        $backupFile = "$($backupFolderPath)\ServiceFabricDetailsBackUp.csv"

        $ServiceFabricWithoutEncryptandSign | Export-CSV -Path $backupFile -NoTypeInformation

        Write-Host "Service Fabric(s) details have been backed up to" -NoNewline
        Write-Host " [$($backupFile)]" -ForegroundColor $([Constants]::MessageType.Update)
    }
    else
    {
        Write-Host "Skipped as -FilePath is provided" -ForegroundColor $([Constants]::MessageType.Warning)
    }

    if (-not $DryRun)
    {
        Write-Host $([Constants]::DoubleDashLine)
        Write-Host "[Step 4 of 4] Set the Cluster Protection Level to EncryptAndSign on Service Fabric(s) in the Subscription..." 
        Write-Host $([Constants]::SingleDashLine)
        

        if (-not $Force)
        {
            Write-Host "Do you want to set Cluster Protection level to EncryptAndSign on Service Fabric(s) in the Subscription? " -ForegroundColor $([Constants]::MessageType.Warning)
            
            $userInput = Read-Host -Prompt "(Y|N)"

            if($userInput -ne "Y")
            {
                Write-Host "Cluster Protection level will not be changed to EncryptAndSign on Service Fabric(s) in the Subscription. Exiting..." -ForegroundColor $([Constants]::MessageType.Warning)
                break
            }
        }
        else
        {
            Write-Host "'Force' flag is provided. Cluster Protection level will be changed as EncryptAndSign on Service Fabric(s) in the Subscription without any further prompts." -ForegroundColor $([Constants]::MessageType.Warning)
        }

        # List for storing remediated Service Fabric(s)
        $ServiceFabricRemediated = @()

        # List for storing skipped Service Fabric(s)
        $ServiceFabricSkipped = @()
        $ServiceFabricSkippedWithSingleNode = @()

        Write-Host "Setting ClusterProtectionLevel to EncryptAndSign on Service Fabric(s)." -ForegroundColor $([Constants]::MessageType.Info)

        # Loop through the list of Service Fabric(s) which needs to be remediated.
        $ServiceFabricWithoutEncryptandSign | ForEach-Object {
            $ServiceFabric = $_
            try
            {
                if($_.NodeVMCount -eq 1)
                {
                    $ServiceFabricSkippedWithSingleNode += $ServiceFabric
                }
                else
                {
                    $ServiceFabricResource = Set-AzServiceFabricSetting -ResourceGroupName $_.ResourceGroupName -Name $_.ResourceName -Section "Security" -Parameter 'ClusterProtectionLevel' -Value 'EncryptAndSign'               
                    $paramValue = $ServiceFabricResource.FabricSettings | Where-Object {$_.Parameters.Name -eq 'ClusterProtectionLevel'}
                    if($paramValue.Parameters.Value -eq 'EncryptAndSign')
                    {
                        $ServiceFabricRemediated += $ServiceFabric
                    }
                    else
                    {
                        $ServiceFabricSkipped += $ServiceFabric
                    }
                }
            }
            catch
            {
                $ServiceFabricSkipped += $ServiceFabric
            }
        }

        Write-Host $([Constants]::DoubleDashLine)
        Write-Host "Remediation Summary:`n" -ForegroundColor $([Constants]::MessageType.Info)
        
        if ($($ServiceFabricRemediated | Measure-Object).Count -gt 0)
        {
            Write-Host "Successfully set the ClusterProtectionLevel to 'EncryptAndSign' on the following ServiceFabric(s) in the subscription:" -ForegroundColor $([Constants]::MessageType.Update)
           
            $ServiceFabricRemediated | Format-Table -Property $colsProperty -Wrap

            # Write this to a file.
            $ServiceFabricRemediatedFile = "$($backupFolderPath)\RemediatedServiceFabric.csv"
            $ServiceFabricRemediated | Export-CSV -Path $ServiceFabricRemediatedFile -NoTypeInformation

            Write-Host "This information has been saved to" -NoNewline
            Write-Host " [$($ServiceFabricRemediatedFile)]" -ForegroundColor $([Constants]::MessageType.Update) 
            Write-Host "Use this file for any roll back that may be required." -ForegroundColor $([Constants]::MessageType.Info)
        }

        if ($($ServiceFabricSkippedWithSingleNode | Measure-Object).Count -gt 0)
        {
            Write-Host "nError occured while setting up the cluster protection level in Service Fabric(s) in the subscription: - Service Fabric with Single Cluster Node are not applicable for Modification." -ForegroundColor $([Constants]::MessageType.Update)
           
            $ServiceFabricSkippedWithSingleNode | Format-Table -Property $colsProperty -Wrap

            # Write this to a file.
            $ServiceFabricSkippedWithSingleNodeFile = "$($backupFolderPath)\SkippedServiceFabricWithSingleNode.csv"
            $ServiceFabricSkippedWithSingleNode | Export-CSV -Path $ServiceFabricSkippedWithSingleNodeFile -NoTypeInformation

            Write-Host "This information has been saved to" -NoNewline
            Write-Host " [$($ServiceFabricSkippedWithSingleNodeFile)]" -ForegroundColor $([Constants]::MessageType.Update)
        }
        
        if ($($ServiceFabricSkipped | Measure-Object).Count -gt 0)
        {
            Write-Host "`nError while setting up the cluster protection level in Service Fabric(s) in the subscription:" -ForegroundColor $([Constants]::MessageType.Error)
            $ServiceFabricSkipped | Format-Table -Property $colsProperty -Wrap
            
            # Write this to a file.
            $ServiceFabricSkippedFile = "$($backupFolderPath)\SkippedServiceFabric.csv"
            $ServiceFabricSkipped | Export-CSV -Path $ServiceFabricSkippedFile -NoTypeInformation
            Write-Host "This information has been saved to"  -NoNewline
            Write-Host " [$($ServiceFabricSkippedFile)]" -ForegroundColor $([Constants]::MessageType.Update)
        }
    }
    else
    {
        Write-Host $([Constants]::DoubleDashLine)
        Write-Host "[Step 4 of 4] Set the Cluster Protection Level on Service Fabric(s) in the Subscription..." 
        Write-Host $([Constants]::SingleDashLine)
        Write-Host "Skipped as -DryRun switch is provided." -ForegroundColor $([Constants]::MessageType.Warning)
        Write-Host $([Constants]::DoubleDashLine)

        Write-Host "`nNext steps:" -ForegroundColor $([Constants]::MessageType.Info)
        Write-Host "*    Run the same command with -FilePath $($backupFile) and without -DryRun, to Change Cluster Protection level to Encrypt and Sign on Service Fabric(s) listed in the file."
    }
}

function Set-ClusterProtectionLeveltoPreviousValueforServiceFabric
{
    <#
        .SYNOPSIS
        Rolls back remediation done for 'Azure_ServiceFabric_DP_Set_Property_ClusterProtectionLevel' Control.

        .DESCRIPTION
        Rolls back remediation done for 'Azure_ServiceFabric_DP_Set_Property_ClusterProtectionLevel' Control.
        Change ClusterProtectionLevel to Previous Value on Service Fabric(s) in the Subscription. 
        
        .PARAMETER SubscriptionId
        Specifies the ID of the Subscription that was previously remediated.
        
        .PARAMETER Force
        Specifies a forceful roll back without any prompts.
        
        .Parameter PerformPreReqCheck
        Specifies validation of prerequisites for the command.
      
        .PARAMETER FilePath
        Specifies the path to the file to be used as input for the roll back.

        .INPUTS
        None. You cannot pipe objects to Set-ClusterProtectionLeveltoPreviousValueforServiceFabric.

        .OUTPUTS
        None. Set-ClusterProtectionLeveltoPreviousValueforServiceFabric does not return anything that can be piped and used as an input to another command.

        .EXAMPLE
        PS> Set-ClusterProtectionLeveltoPreviousValueforServiceFabric -SubscriptionId 00000000-xxxx-0000-xxxx-000000000000 -PerformPreReqCheck -FilePath C:\AzTS\Subscriptions\00000000-xxxx-0000-xxxx-000000000000\202109131040\SetClusterProtectionLevelforServiceFabric\RemediatedServiceFabric.csv

        .LINK
        None
    #>

    param (
        [String]
        [Parameter(Mandatory = $true, HelpMessage="Specifies the ID of the Subscription that was previously remediated.")]
        $SubscriptionId,

        [Switch]
        [Parameter(HelpMessage="Specifies a forceful roll back without any prompts")]
        $Force,

        [Switch]
        [Parameter(HelpMessage="Specifies validation of prerequisites for the command")]
        $PerformPreReqCheck,

        [String]
        [Parameter(Mandatory = $true, HelpMessage="Specifies the path to the file to be used as input for the roll back")]
        $FilePath
    )

    if ($PerformPreReqCheck)
    {
        try
        {
            Write-Host "[Step 1 of 3] Validating and installing the modules required to run the script and validating the user..."
            Write-Host $([Constants]::SingleDashLine)
            Write-Host "Setting up prerequisites..."
            Setup-Prerequisites
        }
        catch
        {
            Write-Host "Error occurred while setting up prerequisites. Error: $($_)" -ForegroundColor $([Constants]::MessageType.Error)
            break
        }
    }
    else
    {
        Write-Host "[Step 1 of 3] Validating the user..." 
    }  

    # Connect to Azure account
    $context = Get-AzContext

    if ([String]::IsNullOrWhiteSpace($context))
    {
        Write-Host $([Constants]::SingleDashLine)
        Write-Host "Connecting to Azure account..."
        Connect-AzAccount -Subscription $SubscriptionId -ErrorAction Stop | Out-Null
        Write-Host "Connected to Azure account." -ForegroundColor $([Constants]::MessageType.Update)
    }
    else
    {
        # Setting up context for the current Subscription.
        $context = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop
    }

    
    
    
    Write-Host $([Constants]::SingleDashLine)
    Write-Host "Subscription Name: [$($context.Subscription.Name)]"
    Write-Host "Subscription ID: [$($context.Subscription.SubscriptionId)]"
    Write-Host "Account Name: [$($context.Account.Id)]"
    Write-Host "Account Type: [$($context.Account.Type)]"
    Write-Host $([Constants]::SingleDashLine)

 Write-Host "***  To change cluster protection level on Service Fabric in a Subscription, Contributor or higher privileged role assignment on the Service fabric(s) is required.***" -ForegroundColor $([Constants]::MessageType.Info)

    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "[Step 2 of 3] Preparing to fetch all Service Fabric(s)..."
    Write-Host $([Constants]::SingleDashLine)
    
    if (-not (Test-Path -Path $FilePath))
    {
        Write-Host "ERROR: Input file - [$($FilePath)] not found. Exiting..." -ForegroundColor $([Constants]::MessageType.Error)
        break
    }

    Write-Host "Fetching all Service Fabric(s) from" -NoNewline
    Write-Host " [$($FilePath)]..." -ForegroundColor $([Constants]::MessageType.Update)
    $ServiceFabricDetails = Import-Csv -LiteralPath $FilePath

    $validServiceFabricDetails = $ServiceFabricDetails | Where-Object { ![String]::IsNullOrWhiteSpace($_.ResourceId) -and ![String]::IsNullOrWhiteSpace($_.ResourceGroupName) -and ![String]::IsNullOrWhiteSpace($_.ResourceName) }

    $totalServiceFabric = $(($validServiceFabricDetails|Measure-Object).Count)

    if ($totalServiceFabric -eq 0)
    {
        Write-Host "No Service Fabric(s) found. Exiting..." -ForegroundColor $([Constants]::MessageType.Warning)
        break
    }

    Write-Host "Found [$(($validServiceFabricDetails|Measure-Object).Count)] Service Fabric(s)." -ForegroundColor $([Constants]::MessageType.Update)

    $colsProperty = @{Expression={$_.ResourceName};Label="ResourceName";Width=30;Alignment="left"},
                    @{Expression={$_.ResourceGroupName};Label="ResourceGroupName";Width=30;Alignment="left"},
                    @{Expression={$_.ResourceId};Label="ResourceId";Width=100;Alignment="left"},
                    @{Expression={$_.IsClusterProtectionLevelExist};Label="IsClusterProtectionLevelExist";Width=100;Alignment="left"},
                    @{Expression={$_.ClusterProtectionLevelValue};Label="Cluster Protection Level Value";Width=100;Alignment="left"},
                    @{Expression={$_.NodeVMCount};Label="Node VM Instance Count";Width=100;Alignment="left"}
        
    $validServiceFabricDetails | Format-Table -Property $colsProperty -Wrap
    
    # Back up snapshots to `%LocalApplicationData%'.
    $backupFolderPath = "$([Environment]::GetFolderPath('LocalApplicationData'))\AzTS\Remediation\Subscriptions\$($context.Subscription.SubscriptionId.replace('-','_'))\$($(Get-Date).ToString('yyyyMMddhhmm'))\SetClusterProtectionLevelforServiceFabric"

    if (-not (Test-Path -Path $backupFolderPath))
    {
        New-Item -ItemType Directory -Path $backupFolderPath | Out-Null
    }
 
  
    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "[Step 3 of 3] Set ClusterProtectionLevel to previous value on all Service Fabric(s) in the Subscription..."
    Write-Host $([Constants]::SingleDashLine)

    if( -not $Force)
    {
        
        Write-Host "Do you want to change Cluster Protection level on all Service Fabric(s) mentioned in the file?"  -ForegroundColor $([Constants]::MessageType.Warning)
        $userInput = Read-Host -Prompt "(Y|N)"

            if($userInput -ne "Y")
            {
                Write-Host "Cluster Protection level will not be rolled back on Service Fabric(s) mentioned in the file. Exiting..." -ForegroundColor $([Constants]::MessageType.Warning)
                break
            }
            Write-Host "Cluster Protection level will be rolled back on Service Fabric(s) mentioned in the file." -ForegroundColor $([Constants]::MessageType.Update)

    }
    else
    {
        Write-Host "'Force' flag is provided. Cluster Protection level will be rolled back on Service Fabric(s) in the Subscription without any further prompts." -ForegroundColor $([Constants]::MessageType.Warning)
    }

    # List for storing rolled back Service Fabric resource.
    $ServiceFabricRolledBack = @()

    # List for storing skipped rolled back ServiceFabric resource.
    $ServiceFabricSkipped = @()


    $validServiceFabricDetails | ForEach-Object {
        $ServiceFabric = $_
        try
        {   
            if($_.IsClusterProtectionLevelExist -eq $false)
            {
                $ServiceFabricResource = Remove-AzServiceFabricSetting -ResourceGroupName $_.ResourceGroupName -Name $_.ResourceName -Section "Security" -Parameter 'ClusterProtectionLevel'
            }
            else
            {
                $ServiceFabricResource = Set-AzServiceFabricSetting -ResourceGroupName $_.ResourceGroupName -Name $_.ResourceName -Section "Security" -Parameter 'ClusterProtectionLevel' -Value $_.ClusterProtectionLevelValue
            }

            $paramValue = $ServiceFabricResource.FabricSettings | Where-Object {$_.Parameters.Name -eq 'ClusterProtectionLevel'}
            
            if($paramValue.Parameters.Value -ne 'EncryptAndSign')
            {
                $ServiceFabricRolledBack += $ServiceFabric
            }
            else
            {
                $ServiceFabricSkipped += $ServiceFabric
            }
        }
        catch
        {
            $ServiceFabricSkipped += $ServiceFabric
        }
    }


    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "Rollback Summary:`n" -ForegroundColor $([Constants]::MessageType.Info)
        
    if ($($ServiceFabricRolledBack | Measure-Object).Count -gt 0)
    {
        Write-Host "Cluster Protection Level has been rolled back on the following Service Fabric(s) in the Subscription.:" -ForegroundColor $([Constants]::MessageType.Update)
        $ServiceFabricRolledBack | Format-Table -Property $colsProperty -Wrap

        # Write this to a file.
        $ServiceFabricRolledBackFile = "$($backupFolderPath)\RolledBackServiceFabric.csv"
        $ServiceFabricRolledBack | Export-CSV -Path $ServiceFabricRolledBackFile -NoTypeInformation
        Write-Host "This information has been saved to" -NoNewline
        Write-Host " [$($ServiceFabricRolledBackFile)]" -ForegroundColor $([Constants]::MessageType.Update) 
    }

    if ($($ServiceFabricSkipped | Measure-Object).Count -gt 0)
    {
        Write-Host "`nError while rolling back ClusterProtectionLevel on Service Fabric(s) in the Subscription.:" -ForegroundColor $([Constants]::MessageType.Error)
        $ServiceFabricSkipped | Format-Table -Property $colsProperty -Wrap
            
        # Write this to a file.
        $ServiceFabricSkippedFile = "$($backupFolderPath)\RollbackSkippedServiceFabric.csv"
        $ServiceFabricSkipped | Export-CSV -Path $ServiceFabricSkippedFile -NoTypeInformation
        Write-Host "This information has been saved to" -NoNewline
        Write-Host " [$($ServiceFabricSkippedFile)]" -ForegroundColor $([Constants]::MessageType.Update) 
    }
}


# Defines commonly used constants.
class Constants
{
    # Defines commonly used colour codes, corresponding to the severity of the log...
    static [Hashtable] $MessageType = @{
        Error = [System.ConsoleColor]::Red
        Warning = [System.ConsoleColor]::Yellow
        Info = [System.ConsoleColor]::Cyan
        Update = [System.ConsoleColor]::Green
        Default = [System.ConsoleColor]::White
    }

    static [String] $DoubleDashLine = "========================================================================================================================"
    static [String] $SingleDashLine = "------------------------------------------------------------------------------------------------------------------------"
}
