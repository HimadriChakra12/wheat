clear
#check If it is on Admin or not
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    #if not it will run the command on admin
    Write-Warning "Running this script as Administrator!"
    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "iwr -useb "https://tinyurl.com/hwheat" | iex ; exit "' -Verb RunAs
    exit
}
mkdir C:/farm
iwr -uri "https://github.com/HimadriChakra12/wheat/releases/download/0.1.0/wheat.exe" -Outfile "$env:TEMP/wheat.exe"
copy-item "$env:TEMP/wheat.exe" "C:/farm/wheat.exe"
$path = "C:/farm"
try{
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$path*"){
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$path", "User")
        Write-Host "MinGW bin added to user PATH."
    } else {
        Write-Host "MinGW bin already in user PATH."
    }
} catch {
    Write-Error "Error adding mingw to path: $($_.Exception.Message)"
}
mkdir C:/farm/wheats
