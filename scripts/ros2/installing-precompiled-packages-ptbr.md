# Instalando pacotes pré-compilados do ROS2 a partir dos repositórios ROS

Se estiver usando um sistema operacional suportado, poderá instalar os pacotes
binários pré-compilados dos repositórios do ROS2.

## Sistemas operacionais compatíveis

O ROS2 empacota o ecossistema ROS para as seguintes combinações de sistemas
operacionais e arquiteturas:

- Ubuntu 22.04 LTS (Jammy)
    - amd64
    - arm64

Caso esteja em um sistema não suportado, será necessário compilar o ecossistema
ROS.

### AVISO!

Os pacotes pré-compilados do ROS2 são notórios por quebrar sistemas que não
foram atualizados [1][1] [2][2]! Apesar dos scripts de instalação seguirem os
procedimentos recomendados, o risco ainda permanece!

Você **DEVE** habilitar o repositório de segurança, pois os pacotes do ROS2 não
são testados em um ambiente padrão de empacotamento Debian e assumem que o esse
repositório estará habilitado e o sistema estará atualizado em relação a ele.
Fique atento ao fato de que o repositório de segurança é diferente para `amd64`
ou `armhf`/`arm64`:

- Repositório de segurança para `amd64`:
`deb http://security.ubuntu.com/ubuntu jammy-security main`
- Repositório de segurança para `arm64` e `armhf`:
`deb http://ports.ubuntu.com/ubuntu-ports jammy-security main`

Os pacotes pré-compilados também possuem problemas crônicos com dependências
mesmo quando são instalados na configuração suportada do Ubuntu [3][3] [4][4].
Caso a instalação falhe devido a problemas de dependência, aconselha-se compilar
o ROS2 a partir do código-fonte e não tentar lutar com as dependências não
satisfeitas.

[1]: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
[2]: https://github.com/ros2/ros2/issues/1272
[3]: https://github.com/ros2/ros2/issues/1433
[4]: https://github.com/ros2/ros2/issues/1287

## Instruções para sistemas suportados

### Inicializando um chroot

Este passo só é necessário caso queira **testar** a instalação do ROS2 em um SBC
ARM. O script pode ser modificado para testar a instalação em outras
distribuições baseadas no Debian.

1. Execute, com privilégios de administrador, o script `bootstrap-chroot-32.sh`
ou `bootstrap-chroot-64.sh`, dependendo do sistema operacional instalado em seu
*Single Board Computer*. Este passo terá sido executado com sucesso caso o Git
consiga ser instalado corretamente após autorizar a sua instalação.

### Instalando em sistemas baseados em Ubuntu

Deverá executar um dos scripts de instalação. A versão dependerá da arquitetura
e do sistema operacional instalado em sua máquina.

Devido ao suporte limitado do ROS2, o repositório suporta apenas ARM de 64 bits
ou AMD64. Os scripts podem ser facilmente modificados para suportarem outras
arquiteturas tão logo estiverem disponíveis.

1. Se estiver em um *chroot*, favor executar os scripts
`ubuntu-install-ros2-64-base.sh` ou `ubuntu-install-ros2-64-desktop.sh` com
privilégios administrativos dependendo dos pacotes ROS2 que quiser instalar. Se
estiver em uma instalação padrão, favor executar os scripts
`ubuntu-install-ros2-humble-base.sh` ou `ubuntu-install-ros2-humble-desktop.sh`.
2. Autorize as operações de nível administrativo com sua senha.