# Create new GPO
New-GPO -Name "Disable Mobile Hotspots" | New-GPLink -Target "OU=Domain Computers,DC=contoso,DC=com"

# Import group policy module
Import-Module GroupPolicy

# Get new GPO
$gpo = Get-GPO -Name "Disable Mobile Hotspots"

# Add new policy to disable mobile hotspots
$gpo | New-GPLink -LinkEnabled Yes -Policies { 
    New-GPRegistryValue -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCM\WiFi\SI" -ValueName DisableIHVServices -Type DWord -Value 1
}

# Update GPO
$gpo | Set-GPRegistryValue -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCM\WiFi\SI" -ValueName DisableIHVServices -Type DWord -Value 1

# Force update
$gpo | Set-GPLink -Target "OU=Domain Computers,DC=contoso,DC=com" -LinkEnabled Yes -Enforced Yes