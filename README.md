# Get a list of remote computer names
$remoteComputers = Get-Content -Path "C:\path\to\computers.txt"

# Iterate through each remote computer
foreach ($computer in $remoteComputers) {
    # Check if the remote computer is online
    $isOnline = Test-Connection -ComputerName $computer -Count 1 -Quiet

    if ($isOnline) {
        Write-Host "Processing computer: $computer"

        # Set the execution policy to allow self-signed scripts on the remote computer
        Invoke-Command -ComputerName $computer -ScriptBlock {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        }

        # Enable PowerShell Remoting on the remote computer
        Invoke-Command -ComputerName $computer -ScriptBlock {
            Enable-PSRemoting -Force
        }

        # Check for available updates on the remote computer
        $session = New-Object -ComObject Microsoft.Update.Session
        $searcher = $session.CreateUpdateSearcher()
        $searchResult = Invoke-Command -ComputerName $computer -ScriptBlock {
            $Session = New-Object -ComObject Microsoft.Update.Session
            $Searcher = $Session.CreateUpdateSearcher()
            $SearchResult = $Searcher.Search("IsInstalled=0 AND Type='Software'")
            $SearchResult
        }

        # Install available updates on the remote computer
        if ($searchResult.Updates.Count -gt 0) {
            $installer = $session.CreateUpdateInstaller()
            $installer.Updates = $searchResult.Updates
            $installationResult = Invoke-Command -ComputerName $computer -ScriptBlock {
                $Installer = $Session.CreateUpdateInstaller()
                $Installer.Updates = $using:searchResult.Updates
                $InstallationResult = $Installer.Install()
                $InstallationResult
            }

            # Check the installation result
            if ($installationResult.RebootRequired) {
                Write-Host "Updates installed successfully on $computer. A reboot is required to complete the installation process."
            } else {
                Write-Host "Updates installed successfully on $computer."
            }
        } else {
            Write-Host "No updates are available for $computer."
        }
    } else {
        Write-Host "Computer $computer is not online or not responding."
    }
}
