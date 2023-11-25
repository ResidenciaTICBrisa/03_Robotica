# Instalando ROS1 usando pacotes nativos

O ROS1 foi empacotado nativamente [1][1] pelas seguintes distribuições baseadas
no Debian GNU/Linux:

- Debian
    - Stretch (9): ROS 1.7
    - Buster (10): ROS 1.12
    - Bullseye (11): ROS 1.16
    - Bookworm (12): ROS 1.16
- Ubuntu
    - Xenial (16.04): ROS 1.5
    - Bionic (18.04): ROS 1.10
    - Eoan (19.10): ROS 1.14
    - Focal (20.04): ROS 1.15
    - Groovy (20.10): ROS 1.16
    - Hirsute (21.04): ROS 1.16
    - Impish (21.10): ROS 1.16
    - Jammy (22.04): ROS 1.16
    - Kinetic (22.10): ROS 1.16
    - Lunar (23.04): ROS 1.16

[1]: https://qa.debian.org/madison.php?package=ros-desktop-full&table=all&a=&c=&s=#

## Instalando em distribuições baseadas no Debian

Distribuições baseadas no Debian usam o `apt` como uma interface que abstrai o
`dpkg`. Pacotes podem ser instalados usando:

```
apt install nome-do-pacote
```

### Instalando no Debian e no Ubuntu

Os seguintes pacotes importantes do ROS1 estão disponíveis nos repositórios do
Debian e do Ubuntu:

- `ros-desktop-full-dev`: `ros-desktop-full` e as dependências necessárias para
compilá-lo
- `ros-desktop-full`
- `ros-desktop`: diferentemente da compilação original (upstream), este pacote
não inclui os tutoriais e o `rosdlint`, que deve ser compilado a partir do
código-fonte caso necessário
- `ros-base`: provê todo o sistema básico do ROS
- `ros-core`: diferente do *upstream*, não é incluído o `geneus` e o
`rosbag_migration_rule`, que devem ser compilados a partir do código-fonte caso
necessário