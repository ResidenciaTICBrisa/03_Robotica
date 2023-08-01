# Instalação do Robot Settings no Ubuntu 22.04 

O Robot Settings é um programa usado para configurar e gerenciar robôs da Softbank Robotics.

Entretanto, até o momento da criação desse tutorial, o Robot Settings é compatível (em distribuições Ubuntu) apenas na versão 16.04 (Xenial Xerus).

Para contornar o problema, criaremos uma máquina virtual (VM) com **QEMU/KVM** usando o **Virt Manager**.

## Requisitos

- Ubuntu 22.04 (Jammy Jellyfish)
- Cópia baixada da ISO do Ubuntu 16.04 (Xenial Xerus)
- Ao menos 50GB de espaço livre no disco rígido
- Ao menos 8GB de RAM
- Processador compatível com aceleração baseada em KVM

### Verificando compatibilidade

Para verificar a compatibilidade, pode-se executar o comando `kvm-ok` do pacote `cpu-checker` como superuser.

```
sudo apt update
sudo apt install cpu-checker
sudo kvm-ok
```

## Instalando dependencias necessárias

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

## Habilitando o libvirtd

```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

> Obs.: necessário reiniciar o sistema após esse passo.

## Criando VM no Virt Manager

- No navegador de aplicativos do Ubuntu, procure e execute o Virt Manager
- Na aba arquivo, selecione a opção "Nova máquina virtual"
- Selecione "Mídia de instalação ISO ou CDROM", clique em `Navegar` e procure a opção `Navegar localmente`
- Selecione o arquivo ISO do Ubuntu 16.04, deixe marcado "Detectar automaticamente mídia (...)" ou selecione a versão 16.04 manualmente
- Caso apareça uma prompt sobre permissão de acesso, clique em `Sim`
- Separe a memória e o número de CPUs desejados para a VM (recomendação: deixe pelo menos 4GB de RAM e 4 CPUs para seu computador físico)
- Marque a opção "Habilitar armazenamento para esta máquina virtual" e reserve o espaço desejado (recomendação: pelo menos 10GB)
- Dê um nome para a VM (use nomes simples para melhor manipulação)
- Clique em `Concluir` para criar a VM

## Instalando Ubuntu 16.04 na VM

Com a VM iniciada, realize a instalação do Ubuntu 16.04 normalmente:

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

## Instalando Robot Settings

Os seguintes passos devem ser realizados dentro da VM com Ubuntu 16.04.

### Download do Robot Settings 

- Abra o navegador
- Acesse o [Site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares)
- Abra a opção "Robot Settings"
- No sub-menu "Linux (2.8.6 and later)", clique sobre "Robot Settings 2.8.6 - Setup"
- Deixe selecionado "Save file" e clique em `OK`

### Instalação do Robot Settings

Aperte `CTRL+ALT+T` para abrir o terminal. Execute os comandos abaixo:

```
cd Downloads
chmod +x robot-settings-2.8.6.23-linux64-setup.run
sudo ./robot-settings-2.8.6.23-linux64-setup.run
```

Prosseguindo com a instalação:

- Clique em `Next` até que apareça o botão `Install`
- Clique em `Install`, aguarde a instalação e clique em `Finish`

Com a realização dos passos acima, o Robot Settings estará instalado e operante, podendo ser encontrado no menu de navegação do Ubuntu ou na área de trabalho.

> Cabe ressaltar que, como o Robot Settings **não é compatível com o Ubuntu 22.04**, deve-se sempre acessá-lo através da máquina virtual (com Ubuntu 16.04) gerenciada pelo Virt Manager, para garantir a compatibilidade do sistema.
