if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    #if not it will run the command on admin
    Write-Warning "Run this script as Administrator!"
    exit
}

$path = "C:/farm/wheats/wnvsh"

$docs = @(
    @{url = "https://github.com/HimadriChakra12/wnvsh/releases/download/1.0.0/wnvsh.exe" ; outfile = "$env:TEMP/wnvsh.exe"; file = "C:/farm/wheats/wnvsh/wnvsh.exe"}
    @{url = "https://github.com/HimadriChakra12/swissknife/releases/download/2.0.0/sk.exe" ; outfile = "$env:TEMP/sk.exe"; file = "C:/farm/wheats/swissknife/sk.exe"}
    @{url = "https://github.com/HimadriChakra12/.Pencil/releases/download/1.0.0/pencil.exe"; outfile = "$env:TEMP/pencil.exe"; file = "C:/farm/wheats/pencil/pencil.exe"}
    @{url = "https://github.com/HimadriChakra12/.Pencil/releases/download/1.0.0/pen.exe"; outfile = "$env:TEMP/pen.exe"; file = "C:/farm/wheats/pencil/pen.exe"}
    @{url = "https://github.com/HimadriChakra12/winwery/releases/download/1.0.0/wry.exe" ; outfile = "$env:TEMP/wry.exe"; file = "C:/farm/wheats/winwery/wry.exe"}
    @{url = "https://github.com/HimadriChakra12/swissknife/releases/download/1.0.0/sk.exe" ; outfile = "$env:TEMP/sk.exe"; file = "C:/farm/wheats/swissknife/sk.exe"}
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
        Write-Host "wnvsh added to user PATH." -ForegroundColor cyan
    } else {
        Write-Host "wnvsh already in user PATH." -ForegroundColor green
    }
} catch {
    Write-Error "Error adding wnvsh to path: $($_.Exception.Message)"
}

if (get-command gsudo){
    write-host "Already have gsudo" -ForegroundColor green
} else {
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; [Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iwr -useb https://raw.githubusercontent.com/gerardog/gsudo/master/installgsudo.ps1 | iex"
}

