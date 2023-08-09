# Instruções de instalação do ROS1 (Noetic) no Ubuntu 20.04

Guia de instalação do ROS1 em uma máquina nativa ou máquina virtual no Ubuntu 20.04

## Instruções para o método manual de instalação

Conforme instruções disponibilizadas na ROS wiki.

## Requisitos

- Sistema com Ubuntu 20.04 (Focal Fossa);
- Ao menos 4GB de espaço livre no disco rígido;

## Instalação do ROS1

Os seguintes passos devem ser realizados no terminal da VM criada.

### Garantindo que o Ubuntu 20.04 permita o uso de repositórios dos tipos restricted, universe e multiverse:

```
sudo apt update
sudo add-apt-repository restricted
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt update
```

### Preparando o computador para aceitar softwares advindos de 'packages.ros.org' (onde o ROS1 está distribuído):

```
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```

### Instalando ferramentas necessárias e preparando as chaves de autenticação:

```	
sudo apt install curl #Se não tiver o curl instalado ainda
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

### Atualizando a lista de pacotes:

```	
sudo apt update
```

### Instalação do ROS (instalação completa recomendada):
	
> Instalação completa (tudos os recursos da versão padrão + softwares de visualização 2D/3D e percepção 2D/3D):

```	
sudo apt install ros-noetic-desktop-full
```

> Instalação padrão (tudo da versão simples + algumas ferramentas como rqt e rviz):

```
sudo apt install ros-noetic-desktop
```

> Instalação simples (pacotes do ROS, bibliotecas de compilação e comunicação. Sem GUI.)

```
sudo apt install ros-noetic-ros-base
```

* Existem muitos outros pacotes do ROS disponíveis. Para instalá-los, você pode usar:

```
sudo apt install ros-noetic-NOME_DO_PACOTE
```

* Para encontrar os pacotes disponíveis, vá para o ROS Index ou use:

```
apt search ros-noetic
```

### Preparando o ambiente:
	
Você deverá 'fontear' esse script em qualquer terminal **bash** no qual você use o ROS:

```
source /opt/ros/noetic/setup.bash
```

Pode ser conveniente fazer isso automaticamente toda vez que iniciar um novo shell para usar o ROS:

* Caso seja BASH:

```
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
		
* Caso seja zsh:

```
echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc
source ~/.zshrc
```

### Instalando dependências necessárias para construir seus próprios pacotes do ROS futuramente:
	
```
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
```

### Instalando as últimas dependências através do pacote rosdep:

```	
sudo rosdep init
rosdep update
```

### Verificando se a instalação foi feita com sucesso:

```	
dpkg -s ros-noetic-ros
```

Com este tutorial, o ROS 1 - Noetic estará instalado em sua máquina.