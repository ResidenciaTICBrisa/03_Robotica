# Guia de instalação do Choregraphe 2.8.6 (NAO v6)
---

## O que é o Choregraphe?

**Choregraphe** é um programa da **Softbank Robotics** usado para:

- Criar animações, comportamentos, diálogos,
- Testá-los em um robô simulado ou diretamente em um robô real,
- Monitorar e controlar seu robô,
- Enriquecer comportamentos utilizando códigos em Python.

Com o Choregraphe, também é possível criar aplicativos contendo diálogos, serviços e comportamentos poderosos, como interação com pessoas, dança, envio de e-mails, com a possibilidade de desenvolvê-los sem escrever uma única linha de código.

## Requisitos

**Mínimo**

- CPU com 1.5 GHz de frequência
- 2 GB de RAM
- Placa gráfica com OpenGL

**Recomendado**

- CPU com 3.4 GHz (ou mais) de frequência
- 16 GB de RAM
- Placa gráfica com OpenGL

**Sistema Operacional**

Ainda que o Choregraphe seja multiplataforma, recomenda-se a instalação no **Ubuntu 16.04 (Xenial Xerus) - 64 bits**.

## Download

Para baixar o Choregraphe 2.8.6, acesse o [site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares).

Desça até o sub-menu Choregraphe, e na seção "LINUX (2.8.6 and later)", selecione `Choregraphe 2.8.6 - Binaries`.

Quando o download for concluído, extraia o arquivo _**tar.gz**_ no diretório de sua escolha.

> Obs.: O setup está com arquivos corrompidos. É altamente recomendado que você baixe os binários.
> Obs.: O arquivo de binários dispensa uma instalação formal, sendo necessário apenas executar o _launcher_ do programa, conforme explicado abaixo.

## Execução do programa

**Executando o Choregraphe 2.8.6** 

- Acesse o terminal e execute o Choregraphe diretamente.

**Exemplo**: se o arquivo extraído (`choregraphe-suite-2.8.6.23-linux64`) está em "/meu/diretorio", execute o Choregraphe com:

```
"/meu/diretorio/choregraphe-suite-2.8.6.23-linux64/bin/choregraphe_launcher"
```

> **IMPORTANTE**: lembre-se de alterar o caminho no código acima de acordo com o local de extração do tar.gz dos binários baixados!

**Selecionando o robô virtual NAO**

- Na tela que se abre quando se executa o Choregraphe, clique no botão verde com símbolo  de conexão (`Connect to...`).
- Na janela que se abre, selecione o primeiro robô e clique em `Select`.
- O robô que aparece por padrão é o **Pepper**, mas vamos mudá-lo para o **NAO**.
- Expanda a janela do Choregraphe (clique no botão do lado do botão de fechar janela).
- Com o mouse em cima da barra superior (cinza) da janela do Choregraphe, as opções File, Edit, Connection, View e Help aparecerão.
- Clique em `Edit` e em `Preferences`.
- Na aba "Virtual Robot", em "Robot Model", selecione `NAO H25 (V6)` e clique em `OK`. Na janela que se abre, confirme.
- Espere um pouco e o robô virtual será reinicializado com o NAO v6.

**CASO TENHA ERRO DE DESCONEXÃO DO ROBÔ** 

- Caso apareça esse erro, confirme e feche a janela `Preferences`.
- Clique novamente no botão verde `Connect to...`.
- Selecione o primeiro robô e confirme.
- O robô deve ser reiniciado e atualizado para o modelo NAO v6.

> Nota:
> Você pode ter problemas com aceleração gráfica se não tiver com os drivers apropriados. Nesse caso, utilize:
> ```./choregraphe --no-ogre```

