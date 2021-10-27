#! /bin/bash

install_shell() {
    echo -e '\e[0;33mConfigurando zsh como shell\e[0m'
    ## zsh
    sudo apt-get install zsh -y

    curl -L http://install.ohmyz.sh | sh
    sudo chsh -s /usr/bin/zsh ${USER}
    wget https://gist.githubusercontent.com/ajsystem/d63dd73fc6f56e8f9de5723bf5b4e83d/raw/21f004f4e014c37549f206b6689defd84b184e5d/3.zshrc -O ~/.zshrc
}

install_devtools() {
    echo -e '\e[0;33mInstalando herramientas dev/runtimes/sdks\e[0m'

    ## Python
    read -p '¿Instalar Python 3.7? (Y/n)' -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo add-apt-repository ppa:deadsnakes/ppa
        sudo apt update
        sudo apt install python3.7
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python get-pip.py
    fi

    ## NVM | Node Version Manager
        read -p '¿Instalar NVM para manejar Node.js? (Y/n)' -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    fi
}

install_git() {
    echo -e '\e[0;33mInstalando git\e[0m'
    sudo add-apt-repository ppa:git-core/ppa --yes
    sudo apt update
    sudo apt install git -y
    echo 'Configurando parametros de git --global'
    echo 'Ingresa los datos solicitados'
    read -r -p 'Nombre: ' nombre
    read -r -p 'Apellido: ' apellido
    read -r -p 'Email: ' email
    read -r -p 'Git Credential Helper directory (Windows): ' gitcredential
    git config --global user.name "$nombre $apellido"
    git config --global user.email "$email"
    git config --global core.editor 'code --wait'
    git config --global diff.tool vscode
    git config --global merge.tool vscode
    git config --global mergetool.vscode.cmd 'code --wait $MERGED'
    git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
    git config --global credential.helper "$gitcredential"
    git config --global pull.rebase false
}

install_lamp(){
    echo -e '\e[0;33mInstalando LAMP PHP7.4 \e[0m'
    sudo apt-get install apache2
    sudo a2enmod rewrite
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    apt-get update
    sudo apt-get install php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-curl php7.4-json php7.4-gd php-memcached php7.4-intl php7.4-mbstring php7.4-xml php7.4-zip
    sudo apt-get install mariadb-server
    service mysql stop
    sudo usermod -d /var/lib/mysql/ mysql
    service mysql start
    sudo mysql_secure_installation
}

echo -e '\e[0;33mPreparando todo para la instalacion\e[0m'

## General updates
sudo apt-get update
sudo apt-get upgrade -y

## Utilities
sudo apt-get install unzip curl -y
sudo apt install software-properties-common
sudo apt-get install net-tools -y


install_shell
install_git
install_devtools
install_lamp

echo 'Todo listo... reinicia la terminal y procede con el paso 4 para finalizar'

