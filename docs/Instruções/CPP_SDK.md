# Instalação do SDK de C++ para o NAO v6 (NAOqi 2.8)

Para que seja possível desenvolver programas que controlem os robôs, é necessário instalar o SDK (Software Development Kit - Kit de Desenvolvimento de Software) de C++ para o NAO v6 (com NAOqi 2.8).

Esse SDK possui APIs e pacotes importantes para o desenvolvimento de tais programas. 

## Requisitos

- Linux Ubuntu 16.04 (Xenial Xerus);
- Compilador GCC - versão 4.8.2 ou superior;
- Uma IDE de C++ de sua preferência (vide Visual Studio).
- Python 2.7
 
Para verificar a versão do compilador GCC instalado na sua máquina, execute o comando:

```
gcc --version
```

Caso o GCC não esteja instalado no seu sistema, execute:

```
sudo apt update
sudo apt install build-essential
```

# Verifique novamente a versão do GCC

```
gcc --version
```

## qiBuild

O **qiBuild** é uma ferramenta para criar projetos entre sistemas operacionais diversos usando o **CMake** e será necessário para o propósito do presente tutorial.

### Instalação das dependências

Dependências são pacotes necessários para rodar um programa específico. No caso, para instalar o qiBuild serão necessários os seguintes pacotes:

- **build-essential**, que contém as ferramentas necessárias para compilar códigos-fonte;
- **Cmake**, ferramenta para simplificar a compilação entre diversos sistemas operacionais;
- **Python-pip**, gerenciador de instalação de pacotes do Python 2;

```
sudo apt update
sudo apt install build-essential cmake python-pip

# Atualizando versão do pip para última versão de suporte ao Python 2.7
pip install 'pip==20.3.4'
```

### Instalação do qiBuild

Para instalar o qiBuild, execute o seguinte código no terminal:

```
pip2 install qibuild --user
```

> Obs.: **NÃO ATUALIZAR PIP AUTOMATICAMENTE (COMO SUGERE O PIP no TERMINAL)** (o suporte do pip ao Python 2 chegou ao fim, sua atualização automática corrompe o Python 2 do sistema);


### Configuração do qiBuild

Digite o seguinte código. Você deverá escolher o gerador (recomendado usar o Unix Makefiles) e o compilador de sua escolha.

```
qibuild config --wizard
```

Resultado: um arquivo é criado em `~/.config/qi/qibuild.xml`. Ele será compartilhado por todas as worktrees que você criar.

> Obs.: **worktrees** são ambientes de trabalho, nesse caso, do qiBuild.

### Inicialização do qiBuild

1. Será necessário criar uma pasta em um local. Supondo que se crie uma pasta de nome _"worktree"_ na Área de Trabalho, seu caminho será:


> Exemplo de caminho: "**/Área de Trabalho/worktree**"


2. Acesse a pasta em um terminal:

```
cd 'Área de Trabalho'/worktree
```

3. Uma vez dentro da pasta, execute o seguinte comando para inicializar o qiBuild:
```
qibuild init
```

### Testando o qiBuild

Nativamente, existe um exemplo testável intrínseco ao qiBuild, e vamos usá-lo para testar a instalação correta da ferramenta.


1. Criar um diretório dentro da worktree com o comando (lembre-se de estar na worktree no terminal):

```
qisrc create myFirstExample
```

2. Acessar a pasta criada no terminal

```
cd myfirstexample
```

3. Criar o diretorio build dentro da worktree:

```
qibuild configure 
```

> Obs.: note que o diretório "build-sys-linux-x86_64" foi criado dentro do diretório "myfirstexample"

4. Compilar o primeiro programa (Hello World) com o seguinte código:

```
qibuild make
```

5. Para rodar o programa, acesse o diretório build-sys-linux-x86_64/sdk/bin:

```
cd build-sys-linux-x86_64/sdk/bin
```

E execute:

```
./my_first_example
```

> Se a mensagem "Hello, world" aparecer no terminal, a instalação do qiBuild foi concluída com sucesso.

## SDK C++ para NAO v6

### Download

Para baixar o SDK de C++, siga os seguintes passos:

1. Visite o [site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares)
2. Acesse o sub-menu "SDK"
3. Na aba "Linux", selecione "SDKs 2.8.5 - C++ SDK"
4. Na prompt que aparecer, selecione a opção "Salvar arquivo"

> Obs.: Muito cuidado ao selecionar a opção correta de acordo com seu sistema operacional.

### Instalação e configuração

1. Extraia o arquivo baixado no local de preferência

2. Supondo que o nome do arquivo extraído seja "naoqi-sdk-2.8.5.10-linux64", crie um toolchain com o seguinte código (adicione o caminho para a pasta extraída e substitua no código abaixo):

```
$ qitoolchain create minhatoolchain /caminho/para/naoqi-sdk-2.8.5.10-linux64/toolchain.xml
```

Em "minhatoolchain", deve ser inserido um nome de sua preferência.

3. No terminal, acesse sua worktree (criada na seção "qiBuild"):

```
cd caminho/para/worktree
```

4. Configurando ambiente para a toolchain criada:

```
qibuild add-config myconfig -t minhatoolchain --default
```

> Lembre-se de trocar "minhatoolchain" pelo nome criado anteriormente.
