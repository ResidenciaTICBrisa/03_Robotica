# Guia de instalação do Choregraphe 2.1 (NAO v4)
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

Ainda que o Choregraphe 2.1 seja multiplataforma, recomenda-se a instalação no **Ubuntu 16.04 (Xenial Xerus) - 64 bits**.

## Download

Para baixar o Choregraphe 2.1, acesse o [site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares).

Desça até o sub-menu Choregraphe, e na seção do LINUX, clique em `Former versions`.

Na página que se abre, selecione o **setup** do Choregraphe na versão 2.1 (para o NAO v4).

O download será iniciado.

## Instalação

Com o navegador de arquivos do Ubuntu, navegue até o diretório onde o setup baixado se encontra.

Clique no arquivo de setup com o botão direito do mouse, vá em `propriedades` e selecione a aba `permissões`.

Marque a caixa `Permitir a execução desse arquivo como um programa`.

No terminal, abra o diretório onde o setup foi baixado.

Execute o setup com o seguinte código (supondo que o nome do arquivo baixado seja "choregraphe-suite-2.1.4.13-linux64-setup.run"):

```
sudo ./choregraphe-suite-2.1.4.13-linux64-setup.run
```

No wizard que se abre, aceite as permissões, selecione a **Quick install** e, quando for pedido o código de série, insira o seguinte código: `654e-4564-153c-6518-2f44-7562-206e-4c60-5f47-5f45`.

Deixe marcada a opção de iniciar (launch) o Choregraphe para testar se o programa funcionou.
## Execução do programa

**Executando o Choregraphe 2.1** 

Para executar o Choregraphe 2.1, existem duas maneiras diferentes.

1. Pelo ícone da área de trabalho

> Clique duas vezes no ícone do Choregraphe 2.1.

2. Pelo terminal

> Execute o seguinte código: `"/opt/Aldebaran Robotics/Choregraphe Suite 2.1/bin/choregraphe_launcher"` (com as aspas).