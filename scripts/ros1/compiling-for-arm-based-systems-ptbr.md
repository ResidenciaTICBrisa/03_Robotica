# Compilar ROS1 para um SBC ARM (Raspberry Pi e similares) em seu computador

## Pacotes a instalar

```
qemu-system-arm
qemu-utils
qemu-user-static
binfmt-support
devscripts
libguestfs-tools
```

## Instruções

Os scripts são configurados por padrão para compilarem e criarem *chroots*
baseados na instalação do Ubuntu assumida pelo ROS1: um sistema Ubuntu 20.04 LTS
que esteja atualizado em relação ao seu repositório de segurança.

Há variáveis que habilitam a modificação para compilação e geração de *chroots*
para todas as distribuições GNU/Linux suportadas pelo `debootstrap`.

### Inicializando um chroot

Este passo é requerido caso queira compilar e instalar o ROS1 em um SBC baseado
na arquitetura ARM.

1. Execute, com privilégios de administrador, o script `bootstrap-chroot-32.sh`
ou `bootstrap-chroot-64.sh`, dependendo do sistema operacional instalado em seu
*Single Board Computer*. Este passo terá sido executado com sucesso caso o Git
consiga ser instalado corretamente após autorizar a sua instalação.

### Compilando e instalando em sistemas baseados em Ubuntu

Depois de configurar o `chroot`, deverá executar um dos scripts de compilação e
instalação. A versão deles dependerá da arquitetura e do sistema operacional do
seu SBC.

1. Execute, com privilégios de administrador, o script
`ubuntu-compile-install-ros1-32.sh` ou `ubuntu-compile-install-ros1-64.sh`,
dependendo do sistema operacional instalado no SBC.
2. Autorize as operações dentro do ambiente *chroot* usando a senha do usuário
`CHROOTED_USER` definida no script `chroot-env-vars.sh`.
3. O ROS1 será instalado no diretório *home* do `CHROOTED_USER`. Dependendo de
seu sistema operacional, poderá ter que instalar o pacote `ros-dev-tools` ou o
seu equivalente.

### Instalando as dependências do ROS1 após compilá-lo

1. Copiar o diretório com os resultados compilados e os scripts de dependência
para o sistema alvo.
2. Instalar as dependências básicas. Este passo depende do sistema operacional.
3. Execute o script de dependência `ros1-noetic-packages.sh` para instalar a
lista completa de dependências.

#### Instalando as dependências básicas no Ubuntu 20.04 (Focal)

O seguinte script instalará as dependências básicas e executará o script de
dependências.

```bash
sudo apt install --yes git wget software-properties-common
sudo add-apt-repository --yes universe

sudo wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros1.list > /dev/null
sudo apt update

sudo apt install --yes ros-dev-tools

sudo ./ros1-noetic-packages.sh
```