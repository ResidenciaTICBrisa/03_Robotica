# Compilando e instalando manualmente o ROS2 em sistemas baseados em Debian

Como instalar e compilar manualmente o ROS2 a partir de seu código-fonte em
distribuições GNU/Linux baseadas no Debian. Este guia usa o Debian 12 Bookworm
como a distribuição do *chroot*, e requer alguma experiência com GNU/Linux,
administração de sistemas baseados em Debian e *shell scripts*.

O Ubuntu 22.04 é a distribuição oficialmente suportada pelo ROS2 Humble. Será
mais fácil seguir nossos guias específicos que usam scripts de compilação do que
fazer tudo manualmente:

- se deseja instalar pacotes pré-compilados do ROS2 em máquinas `arm64` ou
`amd64`, por favor siga o nosso
[guia de instalação pré-compilada](./installing-precompiled-packages-ptbr.md)
- se deseja compilar o ROS2:
    - para `amd64`, por favor siga o nosso
    [guia de compilação amd64](./compiling-for-amd64-based-systems-ptbr.md)
    - para SBCs (Single Board Computers) `arm64` ou `armhf`, por favor siga
    nosso [guia de compilação SBC](compiling-for-arm-based-systems-ptbr.md)

## Abordagem da Wiki do ROS2

Assim como visto na
[documentação de instalação a partir do código-fonte](https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html).
Essa abordagem compila o software que já existe nos repositórios do Debian ou
que não é relevante para o sistema.

Como o ROS insiste em usar pacotes de seus próprios repositórios, mesmo quando o
Debian ou o Ubuntu constroem o mesmo pacote do mesmo código-fonte, essa
abordagem requer a desinstalação da versão nativa para permitir que o `rosdep`
instale algumas dependências renomeadas.

Essa abordagem é recomendada para o Ubuntu e seus derivados, contanto que o nome
da distribuição seja corretamente substituído no `debootstrap` e nos
repositórios do ROS2.

### Gerando o chroot

```
debootstrap bookworm ./bookworm-chroot http://deb.debian.org/debian
# Não montar vinculando /sys/firmware/efi/efivars
# Não montar vinculando /dev
for i in /dev/pts /proc /sys /run; do sudo mount -B $i $(pwd)/bookworm-chroot$i; done
chroot bookworm-chroot
```

### Desativando as montagens vinculadas (*bound mounts*)

Quando sair do *chroot*, não se esqueça de desmontar os diretórios que foram
montados com vínculo no *chroot*.

```
for i in /dev/pts /proc /sys /run; do umount $(pwd)/bookworm-chroot$i; done
```

### Compilando

```
# Ferramentas para baixar código
apt install git colcon python3-rosdep2 vcstool wget

# Repositórios ROS onde o velho python3-vcstool mora
# ISSO VAI SOBRESCREVER TODOS OS PACOTES DE SISTEMA RELACIONADOS AO ROS!
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu bookworm main" > /etc/apt/sources.list.d/ros2.list
apt update

# Dependências comuns
apt install python3-flake8-docstrings python3-pip python3-pytest-cov

# Outras dependências
apt install python3-flake8-blind-except python3-flake8-builtins python3-flake8-class-newline python3-flake8-comprehensions python3-flake8-deprecated python3-flake8-import-order python3-flake8-quotes python3-pytest-repeat python3-pytest-rerunfailures

# Criar um espaço de trabalho e clonar todos os repositórios
mkdir -p ros2_humble/src
cd ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Instalar ainda mais dependências
# rosdep init
rosdep update

# python3-vcstools quebrado (rosdep acha que é python3-vcstool)
apt remove vcstool
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# Construir o código
# Colcon precisa de dispositivos pty ou vai morrer antes de compilar qualquer coisa
# Se estiver construindo em um ambiente chroot, precisará de montar com vínculo os dispositivos requeridos
cd ros2_humble/
colcon build

# Ler o script de ambiente
# Substitua ".bash" pelo seu shell caso não esteja usando-o
# Valores possíveis são: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Teste os exemplos
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker

. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_py listener
```

## Abordagem da Debian Wiki

Instruções adaptadas da
[Wiki do Debian](https://wiki.debian.org/DebianScience/Robotics/ROS2) e do
lançamento atual do ROS2 LTS
[Humble Hawksbill](https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html).

Essa abordagem remove artefatos desnecessários da fase de construção, já que a
maioria deles já está compilada no Debian ou não são relevantes para a
compilação e instalação do ROS2 Humble ou Rolling no sistema.

Recomenda-se seguir esta abordagem quando compilar no Debian 12, apesar de que
distribuições baseadas mp Ubuntu mais novas que a versão 23.04 provavelmente
empacotaram as mesmas dependências.

### Gerando o chroot

```
debootstrap bookworm ./bookworm-chroot-wiki http://deb.debian.org/debian
# Não montar vinculando /sys/firmware/efi/efivars
# Não montar vinculando /dev
for i in /dev/pts /proc /sys /run; do sudo mount -B $i $(pwd)/bookworm-chroot-wiki$i; done
chroot bookworm-chroot-wiki
# Criar usuário softex com senha softex
useradd --home-dir '/home/softex' --skel '/etc/skel' --create-home --shell '/bin/bash' softex
chpasswd <<< 'softex:softex'
```

### Desativando as montagens vinculadas (*bound mounts*)

Quando sair do *chroot*, não se esqueça de desmontar os diretórios que foram
montados com vínculo no *chroot*.

```
for i in /dev/pts /proc /sys /run; do umount $(pwd)/bookworm-chroot-wiki$i; done
```

### Compilando

```
# Checar suporte a UTF-8
# como root
if command -v locale > /dev/null; then
    if grep --quiet 'UTF-8' <<< "$(locale)"; then
        echo "UTF-8 locale found"
    else
        echo "No UTF-8 locales found! Installation may FAIL!"
    fi
else
    echo "Please install 'locales' package"
fi

# Ferramentas para baixar código
# como root
apt install git colcon python3-rosdep2 vcstool wget

# Criar um espaço de trabalho e clonar todos os repositórios
# como outro usuário
mkdir -p ros2_humble/src
cd /home/softex/ros2_humble
wget https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos
# Remover o que já foi empacotado no Debian
sed -i '/\(ament\|eProsima\|eclipse\|ignition\|osrf\|tango\|urdfdom\|tinyxml_\|loader\|pluginlib\|rcutils\|rcpputils\|test_interface\|testing_tools\|fixture\|rosidl:\)/,+3d' ros2.repos
vcs import src < ros2.repos

# Instalar ainda mais dependências
rosdep update
rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
printf '#!/bin/bash\n' > ros2-humble-packages.sh
printf 'apt install --yes' >> ros2-humble-packages.sh
perl -ne 'print " $+{package}" if /apt\s(?<package>.+)/' <<< "$(rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" 2>/dev/null)" >> ros2-humble-packages.sh
chmod +x ros2-humble-packages.sh

# como root
cd /home/softex/ros2_humble
./ros2-humble-packages.sh

# Construir o código
# Colcon precisa de dispositivos pty ou vai morrer antes de compilar qualquer coisa
# Se estiver construindo em um ambiente chroot, precisará de montar com vínculo os dispositivos requeridos
# como outro usuário
cd /home/softex/ros2_humble
rosdep fix-permissions
rosdep update
rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
colcon build

# Ler o script de ambiente
# Substitua ".bash" pelo seu shell caso não esteja usando-o
# Valores possíveis são: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Teste os exemplos
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker

. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_py listener
```