# Set default font for Microsoft 365 apps

# Define the font name and size
$fontName = "Calibri"
$fontSize = 11

# List of Microsoft 365 apps
$apps = "Word", "Excel", "PowerPoint", "Outlook"

# Loop through each app and set the default font
foreach ($app in $apps) {
    $registryPath = "HKCU:\Software\Microsoft\Office\$app\Common\Formatting\FontMapping"
    $null = New-Item -Path $registryPath -Force
    New-ItemProperty -Path $registryPath -Name "0" -Value "$fontName,,,$fontSize" -PropertyType String -Force
    Write-Host "Default font for $app set to $fontName Regular $fontSize pt"
}

# Notify user
Write-Host "Default font for all Microsoft 365 apps set to $fontName Regular $fontSize pt"