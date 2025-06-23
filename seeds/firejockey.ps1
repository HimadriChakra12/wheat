if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    #if not it will run the command on admin
    Write-Warning "Run this script as Administrator!"
    exit
}

$path = "C:/farm/wheats/firejockey"

$docs = @(
    @{url = "https://github.com/HimadriChakra12/firejockey/releases/download/0.0.1/firejockey.exe" ; outfile = "$env:TEMP/firejockey.exe"; file = "C:/farm/wheats/firejockey/firejockey.exe"}
)

if (-not (test-path $path)){
    mkdir $path | out-null
}


foreach ($doc in $docs){
    iwr -uri $doc.url -OutFile $doc.outfile 
    copy-item $doc.outfile $doc.file -force
}

try{
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$path*"){
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$path", "User")
        Write-Host "firejockey added to user PATH." -ForegroundColor cyan
    } else {
        Write-Host "firejockey already in user PATH." -ForegroundColor green
    }
} catch {
    Write-Error "Error adding firejockey to path: $($_.Exception.Message)"
}

if (get-command gsudo){
    write-host "Already have gsudo" -ForegroundColor green
} else {
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; [Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iwr -useb https://raw.githubusercontent.com/gerardog/gsudo/master/installgsudo.ps1 | iex"
}

