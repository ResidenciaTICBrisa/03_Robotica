# Instruções de instalação do ROS1 (Noetic) no Ubuntu 22.04

Guia de instalação do ROS1 em uma máquina virtual (Ubuntu 20.04) com QEMU/KVM gerenciada pelo Virt Manager no Ubuntu 22.04. 

## Instruções para o método manual de instalação

Conforme instruções disponibilizadas na ROS wiki.

## Requisitos

- Sistema com Ubuntu 22.04 (Jammy Jellyfish);
- Cópia baixada da ISO do Ubuntu 20.04 (Focal Fossa);
- Ao menos 50GB de espaço livre no disco rígido;
- Ao menos 8GB de RAM;
- Processador compatível com aceleração baseada em KVM.

## Instalação da VM com Virt Manager

Uma vez que o ROS1 não possui compatibilidade com o Ubuntu 22.04 (até o momento da criação do presente tutorial), é necessário utilizar uma máquina virtual (VM) com o Ubuntu 20.04, que é a versão do Ubuntu compatível com o ROS1.

### Verificando compatibilidade

Para verificar a compatibilidade, pode-se executar o comando `kvm-ok` do pacote `cpu-checker` como superuser.

```
sudo apt update
sudo apt install cpu-checker
sudo kvm-ok
```

### Instalando dependencias necessárias

```
sudo apt update
sudo apt install qemu-system-x86
sudo apt install qemu-system-gui
sudo apt install qemu-utils
sudo apt install qemu-block-extra
sudo apt install ovmf
sudo apt install libguestfs-tools
sudo apt install virt-manager
```

### Habilitando o libvirtd

```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

> Obs.: necessário reiniciar o sistema após esse passo.

### Criando VM no Virt Manager

- No navegador de aplicativos do Ubuntu, procure e execute o Virt Manager
- Na aba arquivo, selecione a opção "Nova máquina virtual"
- Selecione "Mídia de instalação ISO ou CDROM", clique em `Navegar` e procure a opção `Navegar localmente`
- Selecione o arquivo ISO do Ubuntu 16.04, deixe marcado "Detectar automaticamente mídia (...)" ou selecione a versão 16.04 manualmente
- Caso apareça uma prompt sobre permissão de acesso, clique em `Sim`
- Separe a memória e o número de CPUs desejados para a VM (recomendação: deixe pelo menos 4GB de RAM e 4 CPUs para seu computador físico)
- Marque a opção "Habilitar armazenamento para esta máquina virtual" e reserve o espaço desejado (recomendação: pelo menos 10GB)
- Dê um nome para a VM (use nomes simples para melhor manipulação)
- Clique em `Concluir` para criar a VM

### Instalando Ubuntu 20.04 na VM

Com a VM iniciada, realize a instalação do Ubuntu 20.04 normalmente:

- Com o idioma desejado selecionado, clique em `Instalar o Ubuntu`
- No menu "Preparando para instalar o Ubuntu", deixe a opção "Baixar atualizações enquanto instala o Ubuntu" marcada
- Em "Tipo de instalação", marque "Apagar disco e reinstalar o Ubuntu"
- Clique em `Instalar agora` e em seguida em `Continuar`
- Selecione o fuso local (se você está em Brasília, selecione o fuso "Sao Paulo")
- Selecione o teclado desejado (recomendação: deixar na configuração padrão)
- Preencha os campos de acordo com suas informações
- Clique em `Continuar` e aguarde até o fim da instalação
- Clique em `Reiniciar agora`

> Obs.: após o reinício pós-instalação, é comum as VMs travarem. Se for o caso, no menu superior do Virt Manager há um botão vermelho com uma seta ao lado. Clique na seta e selecione "Forçar desligamento". Confirme e depois reinicie a VM no botão de _start_.

## Instalação do ROS1 na VM

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

* Para encontrar os pacotes disponíveis, vá para o ROS Index [adicionar link] ou use:

```
apt search ros-noetic
```

### Preparando o ambiente:
	
Você deverá 'fontear' esse script em qualquer terminal **bash** no qual você use o ROS:

```
source /opt/ros/noetic/setup.bash
```

Pode ser conveniente fazer isso automaticamente toda vez que iniciar um novo shell para usar o ROS:

* Se for BASH:

```
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
		
* Se for zsh:

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

## Considerações finais

O ROS1 deve ser usado na VM criada. Cabe ressaltar que o Virt Manager permite:

- A criação facilitada de snapshots (estados da VM);
- O uso das portas USB da sua máquina física (host) na máquina virtual (guest).
