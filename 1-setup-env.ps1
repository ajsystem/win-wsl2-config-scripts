
# Install from git iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))
# Instala Chocolatey -- https://chocolatey.org/
function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Instala el paquete $PackageName
function Install-FromChocolatey {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $PackageName
    )
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    choco install $PackageName --yes
}

# Instala modulos PowerShell -- https://www.powershellgallery.com/
function Install-PowerShellModule {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ModuleName,

        [ScriptBlock]
        [Parameter(Mandatory = $true)]
        $PostInstall = {}
    )

    if (!(Get-Command -Name $ModuleName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $ModuleName"
        Install-Module -Name $ModuleName -Scope CurrentUser -Confirm $true
        Import-Module $ModuleName -Confirm

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

# Init Instalaciones
Install-Chocolatey

# Instala paquetes basicos
Install-FromChocolatey 'git'
Install-FromChocolatey 'vscode'
Install-FromChocolatey 'postman'
Install-FromChocolatey 'winrar'
Install-FromChocolatey 'putty.install'
Install-FromChocolatey 'filezilla'
Install-FromChocolatey 'slack'
Install-FromChocolatey 'firacode'

WRITE-Host "Todos los paquetes instalados"
WRITE-Host "Configurando parametros de git --global"
WRITE-Host "Ingresa los datos solicitados"

$Nombre = Read-Host -Prompt 'Nombre: '
$Apellido = Read-Host -Prompt 'Apellido: '
$Email = Read-Host -Prompt 'Email: '

Set-Content $env:USERPROFILE\.gitconfig @"
[user]
	name = $Nombre $Apellido
	email = $Email
[core]
	editor = code --wait
[diff]
	tool = vscode
[merge]
	tool = vscode
[mergetool "vscode"]
	cmd = code --wait $MERGED
[difftool "vscode"]
	cmd = code --wait --diff $LOCAL $REMOTE
[credential]
	helper = manager
"@

WRITE-Host "Se guardo la configuración de .gitconfig"

WRITE-Host "Preparando entorno para instalar WSL2"
wsl --install
Restart-Computer -Confirm