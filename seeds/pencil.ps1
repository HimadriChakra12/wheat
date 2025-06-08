if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    #if not it will run the command on admin
    Write-Warning "Running this script as Administrator!"
    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "iwr -useb "https://tinyurl.com/hpencil" | iex "' -Verb RunAs
    exit
}

$path = "C:/farm/wheats/pencil"

$url1 = "https://github.com/HimadriChakra12/.Pencil/releases/download/1.0.0/pencil.exe" 
$outfile1 = "$env:TEMP/pencil.exe" 
$file1 = "C:/farm/wheats/pencil/pencil.exe"

$url2 = "https://github.com/HimadriChakra12/.Pencil/releases/download/1.0.0/pen.exe" 
$outfile2 = "$env:TEMP/pen.exe" 
$file2 = "C:/farm/wheats/pencil/pen.exe"

if (-not (test-path $path)){
    mkdir $path | out-null
}


iwr -uri $url1 -OutFile $outfile1 
copy-item $outfile1 $file1 -force

iwr -uri $url2 -OutFile $outfile2 
copy-item $outfile2 $file2 -force

try{
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$path*"){
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$path", "User")
        Write-Host "pencil added to user PATH." -ForegroundColor cyan
    } else {
        Write-Host "pencil already in user PATH." -ForegroundColor green
    }
} catch {
    Write-Error "Error adding pencil to path: $($_.Exception.Message)"
}

if (get-command gsudo){
    write-host "Already have gsudo" -ForegroundColor green
} else {
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; [Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iwr -useb https://raw.githubusercontent.com/gerardog/gsudo/master/installgsudo.ps1 | iex"
}

