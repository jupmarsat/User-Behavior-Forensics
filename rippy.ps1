# This is using RegRipper.exe to extract user behavior artifacts.
# Need to get a copy of:
# %UserProfile%\NTUSER.dat
# %UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat
# Download RegRipper: https://github.com/keydet89/RegRipper3.0

Write-Host "Checking for NTUSER.dat and UsrClass.dat files..."

if (!(Test-Path ".\NTUSER.dat") -or !(Test-Path ".\UsrClass.dat")) {
    Write-Host "Please place NTUSER.dat and UsrClass.dat files in the directory running rip.exe"
    Exit
}

# Define an array of extraction tasks
$tasks = @(
    @{ Name = "Shellbags"; FilePath = "C:\Temp\Shellbags_Output.txt"; Command = "cmd.exe /c .\rip.exe -r .\UsrClass.dat -p shellbags | Out-File -FilePath C:\Temp\Shellbags_Output.txt -Encoding utf8" },
    @{ Name = "User Assist"; FilePath = "C:\Temp\UserAssist.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p userassist_tln | Out-File -FilePath C:\Temp\UserAssist.txt -Encoding utf8" },
    @{ Name = "WordWheelQuery"; FilePath = "C:\Temp\WordWheel.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p wordwheelquery | Out-File -FilePath C:\Temp\WordWheel.txt -Encoding utf8" },
    @{ Name = "JumpLists"; FilePath = "C:\Temp\JumpList.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p jumplistdata | Out-File -FilePath C:\Temp\JumpList.txt -Encoding utf8" },
    @{ Name = "Run Most Recently Used (MRU)"; FilePath = "C:\Temp\RunMRU.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p runmru | Out-File -FilePath C:\Temp\RunMRU.txt -Encoding utf8" },
    @{ Name = "RecentDocs"; FilePath = "C:\Temp\RecentDocs.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p recentdocs | Out-File -FilePath C:\Temp\RecentDocs.txt -Encoding utf8" },
    @{ Name = "Open and Save Dialog MRUs"; FilePath = "C:\Temp\OpenAndSave.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p comdlg32 | Out-File -FilePath C:\Temp\OpenAndSave.txt -Encoding utf8" },
    @{ Name = "TypedPaths"; FilePath = "C:\Temp\TypedPaths.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p typedpaths | Out-File -FilePath C:\Temp\TypedPaths.txt -Encoding utf8" },
    @{ Name = "MS Office File MRU"; FilePath = "C:\Temp\OfficeMRU.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p msoffice | Out-File -FilePath C:\Temp\OfficeMRU.txt -Encoding utf8" },
    @{ Name = "Adobe"; FilePath = "C:\Temp\Adobe.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p adobe | Out-File -FilePath C:\Temp\Adobe.txt -Encoding utf8" },
    @{ Name = "Winzip Archive"; FilePath = "C:\Temp\Winzip.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p winzip | Out-File -FilePath C:\Temp\Winzip.txt -Encoding utf8" },
    @{ Name = "Putty/SSH Keys"; FilePath = "C:\Temp\Putty.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p putty | Out-File -FilePath C:\Temp\Putty.txt -Encoding utf8" },
    @{ Name = "Terminal Server Client MRU"; FilePath = "C:\Temp\RemoteServers.txt"; Command = "cmd.exe /c .\rip.exe -r .\NTUSER.dat -p tsclient | Out-File -FilePath C:\Temp\RemoteServers.txt -Encoding utf8" }
)


# Run each plugin and save
foreach ($task in $tasks) {
    Write-Host "Fetching $($task.Name)"
    Invoke-Expression $task.Command
}

# Create a ZIP file containing only the extracted files created by this script
$zipPath = "C:\Temp\User_Artifacts.zip"
$filesToZip = $tasks.FilePath
if ($filesToZip) {
    Write-Host "creating zip file containing extracted files..."
    Compress-Archive -Path $filesToZip -DestinationPath $zipPath -Force
    Write-Host "ZIP file created at $zipPath"
} else {
    Write-Host "No extracted files found to zip."
}
