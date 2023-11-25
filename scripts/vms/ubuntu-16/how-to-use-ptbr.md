# Configurando e executando uma máquina virtual para desenvolver para o NAO6

## Configuração

Os scripts são flexíveis, mas possuem requisitos para serem executados.

### Pacotes

Considerando uma distyribuição baseada no Debian GNU/Linux, como o Ubuntu ou o
Linux Mint, os scripts precisam que os seguintes pacotes estejam instalados:

|Pacote          |Versão |
|----------------|-------|
|qemu-system-x86 |6.2.0  |
|qemu-utils      |6.2.0  |
|qemu-system-gui |6.2.0  |
|qemu-block-extra|6.2.0  |
|ovmf            |2022.02|
|libguestfs-tools|1.46.2 |
|iproute2        |5.15   |
|nftables        |1.0.2  |

Os pacotes assumem que a virtualização por KVM está habilitada na máquina
anfitriã, aquela que executará as máquinas virtuais, também conhecidas como
máquinas hospedadas ou *virtual machines* (VMs). Essa tecnologia requer um
processador compatível e uma habilitação na UEFI/BIOS (AMD-V, AMD SVM, Intel VT,
Intel VT-x, Intel VMX).

O pacote `cpu-checker` consegue verificar se o KVM está funcionando através do
comando `kvm-ok`, que necessita de permissões de superusuário.

### Estrutura de diretórios esperada

Apesar da modificação fácil, os scripts esperam uma estrutura de diretório
específica:

- `env-vars.sh`, um script que centraliza as configurações da VM
- uma [imagem][1] do disco de instalação do Ubuntu versão 16.04 nomeada como
`ubuntu-16.04-desktop-amd64.iso` (isto pode ser alterado na variável
`IMAGE_LOCATION` do script `env-vars.sh`)

[1]: https://releases.ubuntu.com/releases/xenial/ubuntu-16.04.7-desktop-amd64.iso

A distribuição GNU/Linux usada para instalar o ambiente completo do NAOv6 é o
Ubuntu 16.04 LTS. É muito provável que o mesmo possa ser feito na versão
equivalente do Debian.

Caso o usuário deseje desenvolver programas **apenas** na API C++11 do NAOv6,
pode ser possível usar uma distribuição GNU/Linux mais atualizada, contanto que
tenha suporte para Python 2 e Pip 20.3.4.

### Criando a VM e preparando para compilar o NAOqi do NAOv6

O usuário deve executar os seguintes scripts em sua máquina anfitrião na ordem
em que aparecem abaixo:

1. `reset-main-drive.sh`
2. `first-boot.sh`

Depois de instalar o Ubuntu 16.04 na máquina virtual, ainda é necessário que os
seguintes scripts sejam executados na máquina anfitriã:

1. `update-sources.sh`
2. `inject-home.sh`

Agora, dentro da máquina virtual, também conhecida como máquina hospedada, o
usuário deve executar o script `prepare-naoqi-requirements.sh` para instalar o
Pip 20.3.4.

Por fim, o usuário poderá instalar o ambiente de desenvolvimento do NAOv6
executando o script `install-naov6.sh`.

## Inicializando a Máquina Virtual pela Primeira vez

A imagem é inicializada com os scripts `reset-main-drive.sh` e `first-boot.sh`.
O primeiro cria uma imagem QCOW2, que funciona como o disco rígido da máquina
virtual ou sistema anfitrião, e o segundo inicializa a máquina virtual com o
disco de instalação do Ubuntu 16.

Com o disco criado, execute o script de inicialização e instale o Ubuntu 16 com
as configurações usuais:

- Linguagem e leiaute do teclado: Português Brasileiro (ou putro *locale* UTF-8)
- Apagar o disco e instalar o Ubuntu
- Fuso horário: Sao Paulo (ou o seu fuso horário local)
- Usuário: `softex` (deve ser o mesmo especificado na `VM_USER` do
`env-vars.sh`)

### AVISO

Os scripts esperam um esquema de partição com o *root* unificado. Não separe o
`/home` ou qualquer outro diretório em outras partições, a não ser que saiba
como modificar os scripts que copiam dados para dentro ou a partir da máquina
virtual (sistema anfitrião).

## Executando a VM

De vez em quando, o servidor brasileiro demora demais para sincronizar com o
principal, causando falhas na instalação ou atualização. Para evitar tal
problema, por favor execute o seguinte script, que configurará o repositório do
sistema para o arquivo principal do Ubuntu:

```
./update-sources.sh
```

Não se esqueça de atualizar a lista de pacotes (`apt update`) e atualizá-los
(`apt dist-upgrade`) sempre que houver atualizações disponíveis.

### Como recuperar memória não usada da máquina virtual

Se estiver executando a máquina virtual em um anfitrião com limitações de
memória, recomenda-se qie use a funcionalidade `virtio-balloon`, já incluída nos
scripts. Ela recuperará a memória sem uso da máquina virtual (convidado ou
hospedado) e devolvê-la-á para o computador (anfitrião).

Um *balloon driver* é um driver especial incluído nos kernels de alguns sistemas
operacionais que ajuda os *hypervisors*, programas que executam as máquinas
virtuais, a recuperar memória sem uso dos sistemas convidados. Estes drivers
implementam duas operações: o enchimento e o esvaziamento do balão.

A operação de enchimento é usada para recuperar a memória sem uso: ela faz com
que o driver crie pressão na memória na máquina hospedada, causando atualizações
nas páginas. Essa operação diminui a memória disponível no convidado, mas
possibilita que o anfitrião recupere as páginas que estão sem uso.

A operação de esvaziamento aumenta a memória disponível no hospedado até o seu
limite de memória física. Ela normalmente é feita após uma operação de
esvaziamento de modo a permitir que a máquina virtual possa utilizar a sua
memória física configurada.

#### Como usar o driver *balloon* do QEMU

O driver balão do QEMU é controlado pelo monitor QEMU na implementação fornecida
pelos scripts. O comando `balloon` possui um argumento que especifica o alvo
para o tamanho lógico da máquina virtual:

- se o argumento for menor que o tamanho da memória física configurado para a
VM, o balãp será "inflado" na máquina convidada, e as páginas não usadas serão
recuperadas;
- se o argumento for igual ou maior que o tamanho da memória física configurado
para a VM, o balão será "esvaziado" até que não mais limite o uso da memória na
máquina virtual.

É importante lembrar que o `virtio-balloon` não requer a instalação de qualquer
driver externo na maioria dos convidados baseados em GNU/Linux, já que ele está
incluído no kernel desde 2008 (versão 2.6.25).

É importante lembnrar que a operação de enchimento do balão só deve ser
realizada quando a máquina virtual não está sob pressão de memória. Isso
significa que só se deve tentar recuperar memória **sem uso** da máquina virtual
enquanto ela possuir uma quantidade suficiente de memória livre para continuar
executando sem a necessidade de entrar e, swap.

## Preparando para instalar o NAOqi para o NAOv6

Ubuntu 16.04 has an old version of `pip`. This requires an installation of the
last Python 2 compatible release to be able to download the packages and their
dependencies. These steps can be automated by sending a script to the user's
home on the VM:

O Ubuntu 16.04 tem uma versão antiga do `pip`. Ela não consegue mais baixar
os pacotes e suas dependências. Isso requer que se instale a última versão
compatível com o Python 2. Tais passos podem ser automatizados com o envio de um
script para o diretório `home` do usuário na VM:

```
./inject-home.sh
```

Depois do script ser enviado para o `home`, ele deve ser executado na VM. Ele
irá pedir por privilégios administrativos antes de atualizar o repositório,
instalar as dependências e instalar o Pip:

```
./prepare-naoqi-requirements.sh
```

## Instalando o ambiente de desenvolvimento do NAOv6

Depois de executar o script de preparação, o instalador deve ser executado em
uma nova sessão de terminal. Caso deseje permanecer na mesma sessão, deverá
recarregar o `.bashrc` (`source .bashrc`) para habilitar as modificações feitas
para habilitar o PIP 2 e seus binários.

```
./install-naov6.sh
```

O script de instalação também requer direitos administrativos, pois precisa de
instalar pacotes usados pelos SDKs C++ e Python 2.

### Ativando o Choregraphe

O Choregraphe pode pedir por uma chave de ativação na sua primeira
inicialização. Essa chave está disponível no script de instalação, e também será
impressa no terminal depois da execução do script.

### Configurando o USB do anfitrião

O script `env-vars.sh` tem quatro variáveis que controlam como a máquina virtual
vai se conectar com o dispositivo USB conectado no anfitrião:

- `USB_HOST_BUS`: o identificador do barramento, incluindo os zeros à esquerda
- `USB_HOST_ADDRESS`: o identificador do dispositivo no barramento mencionado
anteriormente, incluindo os zeros à esquerda
- `USB_VENDOR_ID`: o identificador do fabricante do dispositivo em notação
hexadecimal, isto é, o identificador do fabricante precedido por `0x`
- `USB_PRODUCT_ID`: o identificador do produto em notação hexadecimal, isto é, o
identificador do produto precedido por `0x`

As variáveis relacionam-se com a saída do comando `lsusb`:

```
Bus $USB_HOST_BUS Device $USB_HOST_ADDRESS: ID $USB_VENDOR_ID:$USB_PRODUCT_ID MyUSB Device Thing
```

Há dois scripts que conectarão o dispositivo no anfitrião na máquina virtual:

- `run-usb-productid.sh`: conecta apenas o dispositivo com os mesmos
identificadores do fabricante e do produto, contanto que ele esteja conectado
à porta especificada. Requer a especificação de todas as quatro variáveis;
- `run-usb-hostid.sh`: conecta qualquer dispositivo presente na porta
especificada. Requer a especificação somente do barramento e do dispositivo.

O virtualizador usa os arquivos presentes em `/dev/bus/usb` para conectar a VM
ao dispositivo do anfitrião. Isso requer permissões de superusuário na maioria
das máquinas. Para conectar um dispositivo USB do anfitrião à VM, o usuário deve
prover o script com os privilégios suficientes, executando-o como `root` ou com
o comando `sudo`; ou modificar as permissões da interface USB, modificando o seu
grupo para um que o usuário faça parte com `chgrp`, ou modificando o
proprietário do arquivo com `chown`.

#### Exemplo

Considere a seguinte saída do `lsusb`:

```
Bus 001 Device 001: ID 0001:0001 USB Thing 1
Bus 001 Device 002: ID 0001:0002 USB Thing 2
Bus 001 Device 003: ID 0001:0001 USB Thing 1
Bus 002 Device 001: ID 0002:0001 USB Device 1
Bus 002 Device 002: ID 0002:0002 USB Device 2
Bus 002 Device 003: ID 0002:0001 USB Device 1
```

Se alguém deseja conectar o `USB Thing 1`, conectado no barramento `Bus 001`
como o dispositivo de número `003`, é necessário configurar as variáveis em
`env-vars.sh` como:

```
USB_HOST_BUS="001"
USB_HOST_ADDRESS="003"
USB_VENDOR_ID="0x0001"
USB_PRODUCT_ID="0x0001"
```

Antes de executar o script desejado, as permissões devem ser configuradas para
o arquivo USB (`chown the-user /dev/bus/usb/001/003`), ou então o script deve
ser executado com privilégios elevados (`sudo` ou como `root`).

Lembre-se de que, para conectar somente o dispositivo especificado, a máquina
virtual deve ser executada a partir do script `run-usb-productid.sh`. Caso
tivesse escolhido `run-usb-productid.sh`, todos os dispositivos do barramento
`Bus 001` seriam conectados, ambos `USB Thing 1` e `USB Thing 2`.

### Permissões do NAO Flasher

O NAO Flasher requer permissões administrativas na máquina virtual (`sudo` ou
execução como `root`). Caso o `sudo` não consiga encontrar o caminho do comando,
este pode ser encontrado usando-se `command -v flasher`.

## Compilando código em C++

O arcabouço Qibuild requer que todos os projetos estejam dentro de uma árvore de
trabalho (*worktree*). O script de configuração cria uma árvore de trabalho no
diretório `NAO6/worktree`. Ela já é configurada com o SDK C++ como ferramental
padrão, e o CTC também está disponível caso o usuário deseje configurar os seus
projetos para usá-lo.

O caminho da *worktree* é armazenado no `.bashrc` do usuário, na variável
`NAO_QIBUILD_WORKSPACE`.

### Configuração do Qibuild

O script configura os nomes das configurações no `.bashrc` do usuário. As
seguintes variáveis de ambiente armazenam dados importantes para a configuração
de projetos baseados no Qibuild:

- `NAOQI_CPP_QIBUILD_TOOLCHAIN`: o nome do ferramental usado quando ele foi
adicionado à árvore de trabalho
- `NAOQI_CPP_QIBUILD_CONFIG`: o nome da configuração gerado após a adição do SDK
à *worktree*. É a configuração de ferramental padrão.
- `NAOQI_QIBUILD_CTC`: o nome do ferramental de compilação cruzada na árvore de
trabalho.
- `NAOQI_QIBUILD_CTC_CONFIG`: o nome da configuração na *worktree*. Pode ser
usada para substituir o C++ SDK como ferramental do projeto, possibilitando a
criação de binários que podem ser executados diretamente no robô.

### Configuração básica de um projeto

Os seguintes passos criarão e construirão um projeto baseado no C++ SDK na
*worktree* configurada:

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure
qibuild make
```

O SDK C++ é configurado como o ferramental padrão. Caso deseje configurar um
projeto com uma configuração explícita, execute:

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure -c "${NAOQI_CPP_QIBUILD_CONFIG}" my-project
qibuild make -c "${NAOQI_CPP_QIBUILD_CONFIG}" my-project
```

Compilar um projeto que será executado no robô requer uma configuração explícita
para substituir o ferramental padrão pelo capaz de fazer compilação cruzada (NAO
CTC):

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure -c "${NAOQI_QIBUILD_CTC_CONFIG}"
qibuild make -c "${NAOQI_QIBUILD_CTC_CONFIG}"
```

## Conectando ao robô simulado

O robô simulado é um executável chamado `naoqi`, e está localizado no diretório
do ferramental C++. Considerando que as ferramentas foram instaladas usando os
scripts supracitados nas suas configurações padrões, ele estará localizado em:
`/home/softex/NAO6/SDKs/cpp/naoqi-sdk-2.8.5.10-linux64/naoqi`.

O robô simulado sempre deve ser inicializado antes de se executar o Choregraphe
ou o seu módulo desejado. Ele comportar-se-á de maneira similar ao robô físico,
exceto pela sua ausência de câmeras, e iniciará por padrão seu *broker* no
*localhost* (IPv4 127.0.0.1) na porta 9559.

### Simulando no Choregraphe

Caso queira simular seu módulo C++ no Choregraphe, primeiro deve iniciar o
`naoqi` simulado. Depois, é necessário abrir o Choregraphe e conectá-lo ao
*broker* disponível em 127.0.0.1 na porta 9559.

Depois desses passos, deverá ser possível visualizar uma simulação 3D do robô
NAO no painel de visualização do robô. Nesta etapa estará pronto para conectar
o módulo ao robô simulado e verificar seu comportamento na simulação
simplificada oferecida pelo Choregraphe.

## Conectando ao robô

Há três scripts que são usados para conectar a máquina virtual ao seu NAO:

1. `enable-nat-bridge-network.sh`: este script deve ser executado com
privilégios elevados para estabelecer uma ponte com um servidor DHCP atrelado e
um NAT *masquerade*
2. `run-nat-bridge.sh`: este script executa a VM com conectividade à ponte
mencionada anteriormente. Isso é feito por meio de um dispositivo `tap` que o
QEMU vai adicionar automaticamente à ponte usando
`/usr/lib/qemu/qemu-bridge-helper` e `/etc/qemu/bridge.conf`. Ele pode ser
executado por um usuário comum.
3. `disable-nat-bridge-network.sh`: este script deve ser executado com
privilégios elevados para desfazer todas as modificações feitas pelo script que
habilitou o NAT.

### Aviso aos usuários de Docker

O Docker anula todas as configurações de firewall feitas anteriormente. Os
scripts exigem uma configuração padrão de firewall, portanto será necessário
remover todas as tabelas e regras criadas pelo Docker. Recomenda-se parar o
serviço do Docker com `systemctl stop docker.service docker.socket` para evitar
uma reconfiguração surpresa do firewall.

Deverá ser possível restaurar as configurações padrões do firewall usando o
comando: `systemctl stop docker.service docker.socket`. Isso vai quebrar a
conexão à rede de quaisquer contêineres na máquina até que o serviço do Docker
seja reiniciado.

## Como adicionar arquivos manualmente à sua máquina virtual

É possível que deseje adicionar arquivos do sistema anfitrião, a sua máquina
atual, para o convidado, armazenado nas máquinas virtuais. A maneira mais comum
de se fazer isso é usando a tecnologia SSH, mas ela requer a configuração de um
servidor SSH no convidado e de um cliente SSH no anfitrião.

uma maneira mais rápida é adicionar os arquivos diretamente `as imagens das
máquinas virtuais. Essa abordagem requer que as VMs não estejam em execução, ao
contrário da baseada em SSH. É mais conveniente fazer a transferência de
arquivos usando a `guestfish`, uma *shell* de sistema especializada em manipular
imagens de máquinas virtuais.

É possível criar um script baseado no `inject-home.sh`, ou usar o `guestfish` em
seu modo interativo, que funciona de modo semelhante a um *shell* de sistema
comum. Apesar de exigir mais digitação, a segunda abordagem é mais amigável para
usuários iniciantes, e será a explorada neste tutorial.

Primeiramente, deve-se saber o caminho dos arquivos que deseja adicionar à VM, e
a localização desejada deles na máquina virtual. Esses serão parâmetros que
serão usados no comando `copy-in` da `guestfish`, responsável por copiar os
arquivos *para* a VM.

Então, deve-se montar a partição da máquina virtual que possui o caminho de
saída. Essa é a etapa mais complicada, pois requer o conhecimento das partições
presentes no arquivo de imagem da máquina virtual. Caso tenha seguido as
instruções anteriores, e tenha instalado a VM usando as configurações
recomendadas, conseguirá usar os seguintes comandos após executar `guestfish` em
seu terminal com o diretório de trabalho apontando para onde a imagem está
localizada:

```
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda1' '/'
```

Com a partição principal montada, poderá usar o comando `ls` para listar os
arquivos e diretórios. A cópia dos arquivos para a VM é feita através do comando
`copy-in`:

```
# copying a file or directory from the current host directory
copy-in my-file-or-directory /home/softex
# copying a file or directory from an absolute path in the host
copy-in /absolute/path/in/the/host/something /desired/path/in/the/vm
```

Os scripts usam uma sintaxe mais complicada para onter automaticamente o usuário
que foi configurado no arquivo `env-vars.sh`:

```
<!. ./env-vars.sh > /dev/null; echo "copy-in 'my-file' '/home/${VM_USER}/abc'"
```

Depois de copiar todos os arquivos, não se esqueça de desmontar todas as
partições e fechar o `guestfish` antes de rodar a VM:

```
umount-all
exit
```