# Install the Microsoft Graph PowerShell module
if (-not (Get-Module -Name Microsoft.Graph -ListAvailable)) {
    Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
}

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All"

# Function to onboard the device to Intune
Function Onboard-DeviceToIntune {
    Write-Host "Enrolling device to Intune..."
    Start-Process -FilePath "ms-settings:workplace" -ArgumentList "" -Wait
    Write-Host "Ensure you use the appropriate Azure AD credentials to onboard the device to Intune."
}

# Function to onboard the device to Microsoft Defender for Endpoint
Function Onboard-DefenderForEndpoint {
    Write-Host "Onboarding device to Microsoft Defender for Endpoint..."
    
    # Web URL to download the Defender for Endpoint onboarding script
    $OnboardingScriptUrl = "https://example.com/path/to/DefenderOnboardingScript.bat"
    $OnboardingScriptPath = "$env:TEMP\DefenderOnboardingScript.bat"

    try {
        Write-Host "Downloading onboarding script from $OnboardingScriptUrl..."
        Invoke-WebRequest -Uri $OnboardingScriptUrl -OutFile $OnboardingScriptPath
        Write-Host "Onboarding script downloaded to $OnboardingScriptPath."
    } catch {
        Write-Error "Failed to download the onboarding script. Error: $_"
        return
    }

    if (Test-Path $OnboardingScriptPath) {
        Write-Host "Executing the onboarding script..."
        Start-Process -FilePath $OnboardingScriptPath -Wait -NoNewWindow
        Write-Host "Defender for Endpoint onboarding completed."
    } else {
        Write-Error "Onboarding script not found at $OnboardingScriptPath."
    }
}

# Function to create a secure compliance policy
Function Create-SecureCompliancePolicy {
    Write-Host "Creating secure compliance policy..."

    $compliancePolicy = @{
        "@odata.type"                        = "#microsoft.graph.deviceCompliancePolicy";
        displayName                          = "Secure Compliance Policy";
        description                          = "Enforces secure baseline compliance settings.";
        osMinimumVersion                     = "10.0.19044"; # Minimum Windows 10 21H2 or later
        passwordRequired                     = $true;
        passwordMinimumLength                = 12; # Strong password policy
        passwordRequiredType                 = "alphanumeric"; # Require alphanumeric passwords
        passwordExpirationDays               = 60;
        passwordPreviousPasswordBlockCount   = 5;
        deviceThreatProtectionEnabled        = $true;
        deviceThreatProtectionRequiredSecurityLevel = "secure";
        osMaximumVersion                     = "Windows 11"; # Restrict OS to latest
    }

    # Create compliance policy
    Invoke-MgGraphRequest -Method POST -Uri "/deviceManagement/deviceCompliancePolicies" -Body ($compliancePolicy | ConvertTo-Json -Depth 10)
    Write-Host "Secure compliance policy created."
}

# Function to create a secure configuration profile
Function Create-SecureConfigurationProfile {
    Write-Host "Creating secure configuration profile..."

    $configurationProfile = @{
        "@odata.type"        = "#microsoft.graph.deviceConfiguration";
        displayName          = "Secure Baseline Configuration";
        description          = "Applies a secure baseline for managed devices.";
        platformType         = "windows10AndLater";
        settings             = @(
            @{
                settingInstanceId  = "DeviceLock";
                settingDefinitionId = "deviceLockPasswordRequired";
                value              = $true;
            },
            @{
                settingInstanceId  = "BitLocker";
                settingDefinitionId = "bitLockerDriveEncryptionEnabled";
                value              = $true; # Enforce BitLocker
            },
            @{
                settingInstanceId  = "Firewall";
                settingDefinitionId = "firewallEnabled";
                value              = $true; # Enable Windows Firewall
            },
            @{
                settingInstanceId  = "Defender";
                settingDefinitionId = "microsoftDefenderEnabled";
                value              = $true; # Ensure Defender Antivirus is enabled
            }
        )
    }

    # Create configuration profile
    Invoke-MgGraphRequest -Method POST -Uri "/deviceManagement/deviceConfigurations" -Body ($configurationProfile | ConvertTo-Json -Depth 10)
    Write-Host "Secure configuration profile created."
}

# Function to apply a secure Microsoft Security Baseline
Function Apply-SecurityBaseline {
    Write-Host "Applying Microsoft Security Baseline..."

    $baselineTemplate = @{
        "@odata.type"        = "#microsoft.graph.securityBaseline";
        displayName          = "Security Baseline for Secure Environment";
        templateId           = "d1c84e61-9450-4c9d-8fb1-79dd22d55a91"; # Example template ID for Microsoft Security Baseline
    }

    # Assign baseline
    Invoke-MgGraphRequest -Method POST -Uri "/deviceManagement/templates/{templateId}/assign" -Body ($baselineTemplate | ConvertTo-Json -Depth 10)
    Write-Host "Microsoft Security Baseline applied."
}

# Main script execution
Write-Host "Starting Intune onboarding and secure baseline setup..."

# Onboard the device to Intune
Onboard-DeviceToIntune

# Onboard the device to Defender for Endpoint
Onboard-DefenderForEndpoint

# Create a secure compliance policy
Create-SecureCompliancePolicy

# Create a secure configuration profile
Create-SecureConfigurationProfile

# Apply Microsoft Security Baseline
Apply-SecurityBaseline

Write-Host "Intune setup for secure environments is complete. Devices are onboarded with a secure baseline."
