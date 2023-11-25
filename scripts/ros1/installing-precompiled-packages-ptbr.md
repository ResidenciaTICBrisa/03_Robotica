# Instalando pacotes pré-compilados do ROS1 a partir dos repositórios ROS

Se estiver usando um sistema operacional suportado, poderá instalar os pacotes
binários pré-compilados dos repositórios do ROS1.

## Sistemas operacionais compatíveis

O ROS1 empacota o ecossistema ROS para as seguintes combinações de sistemas
operacionais e arquiteturas:

- Ubuntu 20.04 LTS (focal)
    - amd64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - arm64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - armhf
        - ros-noetic-ros-base
        - ros-noetic-desktop
- Debian 10 (buster)
    - amd64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - arm64
        - ros-noetic-ros-base
        - ros-noetic-desktop

Caso esteja em um sistema não suportado, será necessário compilar o ecossistema
ROS1.

### AVISO!

ROS2 precompiled packages are notorious for breaking systems when installed
without upgrading the system [1][1] [2][2]! Although the installation scripts
follow the recommended procedures, and ROS1 does not cite that the same problem
exists for their packages, the risk remains!

Os pacotes pré-compilados do ROS2 são notórios por quebrar sistemas que não
foram atualizados [1][1] [2][2]! Apesar dos scripts de instalação seguirem os
procedimentos recomendados, e do ROS1 não citar que o mesmo problema existe para
os seus pacotes, o risco ainda permanece!

Você **DEVE** habilitar o repositório de segurança, pois os pacotes do ROS1 não
são testados em um ambiente padrão de empacotamento Debian e assumem que o esse
repositório estará habilitado e o sistema estará atualizado em relação a ele.
Fique atento ao fato de que o repositório de segurança é diferente para `amd64`
ou `armhf`/`arm64`:

- Ubuntu Focal
    - Repositório de segurança para `amd64`:
`deb http://security.ubuntu.com/ubuntu focal-security main`
    - Repositório de segurança para `arm64` and `armhf`:
`deb http://ports.ubuntu.com/ubuntu-ports focal-security main`
- Debian Buster
    - Repositório de segurança para `amd64`, `i386`, `arm64` and `armhf`:
`deb https://security.debian.org/debian-security buster/updates main`

Os pacotes pré-compilados também possuem problemas crônicos com dependências
mesmo quando são instalados na configuração suportada do Ubuntu [3][3] [4][4].
Caso a instalação falhe devido a problemas de dependência, aconselha-se compilar
o ROS1 a partir do código-fonte, ou, se possível, instalar os pacotes nativos da
distribuição e não tentar lutar com as dependências não satisfeitas.

[1]: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
[2]: https://github.com/ros2/ros2/issues/1272
[3]: https://github.com/ros2/ros2/issues/1433
[4]: https://github.com/ros2/ros2/issues/1287

## Instruções para sistemas suportados

### Inicializando um chroot

Este passo só é necessário caso queira **testar** a instalação do ROS1 em um SBC
ARM. O script pode ser modificado para testar a instalação em outras
distribuições baseadas no Debian.

1. Execute, com privilégios de administrador, o script `bootstrap-chroot-32.sh`
ou `bootstrap-chroot-64.sh`, dependendo do sistema operacional instalado em seu
*Single Board Computer*. Este passo terá sido executado com sucesso caso o Git
consiga ser instalado corretamente após autorizar a sua instalação.

### Instalando em sistemas baseados em Ubuntu

Deverá executar um dos scripts de instalação. A versão dependerá da arquitetura
e do sistema operacional instalado em sua máquina.

Devido ao suporte limitado do ROS1, o repositório suporta apenas ARM de 64 bits
ou AMD64. ou sistemas ARM de 32 bits (armhf). Os scripts podem ser facilmente
modificados para suportarem outras arquiteturas tão logo estiverem disponíveis.

1. Se estiver em um *chroot*, favor executar os scripts
`ubuntu-install-ros1-32-base.sh`, `ubuntu-install-ros1-32-desktop.sh`,
`ubuntu-install-ros1-64-base.sh`, `ubuntu-install-ros1-64-desktop.sh`,
`ubuntu-install-ros1-64-desktop-full.sh` com privilégios administrativos
dependendo dos pacotes ROS1 que quiser instalar.
2. Autorize as operações de nível administrativo com sua senha.