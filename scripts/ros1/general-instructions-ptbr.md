# Compilando e instalando manualmente o ROS1 em sistemas baseados em Debian

O Ubuntu 20.04  é a distribuição oficialmente suportada pelo ROS1 Noetic.
Felizmente, ao contrário do ROS2, o ROS1 foi empacotado nativamente pelo Debian
e pelo Ubuntu em mais arquiteturas e versões dos sistemas do que o que foi feito
pela equipe do ROS1. Será mais fácil seguir nossos guias específicos do que
fazer tudo manualmente:

- caso deseje instalar os pacotes ROS1 compilados pela equipe do ROS para
máquinas `arm64`, `amd64` ou `armhf`, siga os nosso
[guia de instalação pré-compilado](./installing-precompiled-packages-ptbr.md)
- caso deseje compilar o ROS1:
    - para `amd64`, siga o nosso
    [guia de compilação amd64](./compiling-for-amd64-based-systems-ptbr.md)
    - para SBCs (Single Board Computers) baseados em `arm64` ou `armhf`, como
    Raspberry e Orange Pi, Beaglobone, siga o nosso
    [guia de compilação SBC](compiling-for-arm-based-systems-ptbr.md)
- caso deseje instalar o ROS1 empacotado nativamente em sua distribuição baseada
em Debian, siga o nosso
[guia de instalação pacote nativo](./installing-native-packages-ptbr.md)