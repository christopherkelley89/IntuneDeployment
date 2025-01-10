# Intune Baseline
## Key Features

### Purpose:

Onboards 1-10 machines to MDE services for security and compliance.
Ensures the machine appears in the MDE portal within 5–30 minutes, depending on connectivity and power state.

## Scope:

-Optimized for individual machine onboarding, not intended for large-scale deployment.
Provides troubleshooting guidance and error handling mechanisms.
User Confirmation:

- Prompts the user for consent (Y to continue, N to exit).

## Main Steps
### Preliminary Checks:
- Confirms the script is run with administrator privileges.
- Verifies the machine's architecture and sets appropriate PowerShell paths.

### Registry Modifications:

- Configures registry keys related to:
- Latency settings.
- Data collection policies.
- WMI security settings.

# Microsoft Defender ATP Onboarding 

## Service Operations:

- Starts or verifies the status of the Microsoft Defender for Endpoint Service (SENSE).
Waits for the service to fully initialize.
Onboarding Operations:

- Uses PowerShell to run custom commands for initializing ELAM (Early Launch Anti-Malware).
Writes onboarding data (e.g., organization ID, data center location) to the registry.
Validates that the machine has successfully onboarded by checking registry keys for the onboarding state.

## Error Handling:

- Handles insufficient privileges, registry write failures, service startup failures, and other issues.
Logs errors and troubleshooting information to files or system events.

## Completion:
- Confirms successful onboarding via system events and logs.
- Cleans up temporary files and exits with an appropriate error or success code.

How to Use It
- Execute the script with administrator privileges on the machine you want to onboard. 
- Follow the prompts to confirm and proceed with onboarding.

Limitations
- Designed for individual use, not for mass deployment. 
- Requires manual confirmation and specific configurations tailored to the organization (e.g., organization ID, data center).

## Future Changes
- Further changes will be made to also deploy baseline configuration policies within Intune for various devices (windows, macOS, iOS, android) 
- Ensure the defender portal and Endpoint manager link is connected and working correctly by creating a defender endpoint response policy first which enables the ability to link both endpoint manager and Microsoft security portal
- Will use Microsoft Graph API and will have provided documentation on Azure App registration setup so proper permissions are established
- Prompt user for tenant ID, APPID, and client secret to hook into tenant




