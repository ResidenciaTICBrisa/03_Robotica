# Instalação do SDK de C++ (NAO v4)


Para que seja possível desenvolver programas que controlem os robôs, é necessário instalar o SDK (Software Development Kit - Kit de Desenvolvimento de Software) do NAO v4 para C++.

Esse SDK possui APIs e pacotes importantes para o desenvolvimento de tais programas. 

## Requisitos

- Linux Ubuntu 12.04 (Precise Pangolin) ou superior - **RECOMENDADA: Linux Ubuntu 16.04 (Xenial Xerus)**;
- Compilador GCC - versão 4.4 ou superior;
- Uma IDE de C++ de sua preferência (vide Visual Studio).
 
Para verificar a versão do compilador GCC instalado na sua máquina, execute o comando:

```
gcc --version
```

Caso o GCC não esteja instalado no seu sistema, execute:

```
sudo apt update
sudo apt install build-essential

# Verifique novamente a versão do GCC
gcc --version
```

## qiBuild

O **qiBuild** é uma ferramenta para criar projetos entre sistemas operacionais diversos usando o **CMake** e será necessário para o propósito do presente tutorial.

### Instalação das dependências

Dependências são pacotes necessários para rodar um programa específico. No caso, para instalar o qiBuild serão necessários os seguintes pacotes:

- **build-essential**, que contém as ferramentas necessárias para compilar códigos-fonte;
- **CMake**, ferramenta para simplificar a compilação entre diversos sistemas operacionais;
- **pip (20.3.4)**, gerenciador de instalação de pacotes do python3;

```
sudo apt update
sudo apt install build-essential cmake python-pip
pip install 'pip==20.3.4'
```

### Instalação do qiBuild

Para instalar o qiBuild, execute o seguinte código no terminal:

```
pip install qibuild --user
```

### Configuração do qiBuild

Digite o seguinte código. Você deverá escolher o gerador (recomendado usar o Unix Makefiles) e o compilador de sua escolha.

> Para os testes do presente tutorial, deixar o compilador como "None" não implicará em problemas. Além disso, você sempre pode reconfigurar seu qibuild executando o mesmo código no diretório padrão "/~".

```
qibuild config --wizard
```

Resultado: um arquivo é criado em `~/.config/qi/qibuild.xml`. Ele será compartilhado por todas as worktrees que você criar.

> Obs.: **worktrees** são ambientes de trabalho, nesse caso, do qiBuild.

### Inicialização do qiBuild

1. Será necessário criar uma pasta em um local. Supondo que se crie uma pasta de nome _"worktree"_ na pasta Downloads, seu caminho será:


> Exemplo de caminho: "**~/Downloads/worktree**"
> Obs.: **NÃO** criar worktree em diretórios com acentos ortográficos no nome, pois isso gera erro de decodificação com o qiBuild.


2. Acesse a pasta em um terminal:

```
cd caminho/para/worktree
```

3. Uma vez dentro da pasta, execute o seguinte comando para inicializar o qiBuild (criar pastas ocultas necessárias para a compilação dos programas do NAO v4):

```
qibuild init
```

## SDK C++

### Download

Para baixar o SDK de C++, siga os seguintes passos:

1. Visite o [site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares)
2. Acesse o sub-menu "SDK"
3. Na aba "Linux", clique em `Former Versions`
4. Selecione o C++ SDK (versão 2.1.4) e clique no ícone de download
5. Na prompt que aparecer, selecione a opção "Salvar arquivo"

> Obs.: Muito cuidado ao selecionar a opção correta de acordo com seu sistema operacional.

### Instalação e configuração

1. Extraia o arquivo baixado na worktree criada anteriormente.

2. Supondo que o nome do arquivo extraído seja "naoqi-sdk-2.1.4.13-linux64", acesse o seguinte diretório:

```
cd caminho/para/worktree/naoqi-sdk-2.1.4.13-linux64/doc/dev/cpp/examples
```

3. Crie um toolchain com o seguinte código (adicione o caminho para a pasta extraída e substitua no código abaixo):

```
$ qitoolchain create minhatoolchain /caminho/para/naoqi-sdk-2.1.4.13-linux64/toolchain.xml
```

Em "minhatoolchain", deve ser inserido um nome de sua preferência.

4. Configurando ambiente para a toolchain criada:

```
qibuild add-config minhatoolchain -t minhatoolchain --default
```

### Teste do qiBuild e do SDK

1. Acesse o diretório do teste "core/sayhelloworld" e execute o código abaixo (para evitar possíveis erros de compilação):

```
cd core/sayhelloworld
echo "set(CMAKE_CXX_FLAGS "-D_GLIBCXX_USE_CXX11_ABI=0")" >> CMakeLists.txt
```

2. Compile o hello world de teste usando:

```
qibuild configure
qibuild make
```

3. Execute o binário do sayhelloworld para teste:

```
cd build-minhatoolchain/sdk/bin
./sayhelloworld "Olá"
```

> Caso o binário rode e resulte no erro "Cannot connect to tcp://Olá:9559", o SDK foi instalado com sucesso.