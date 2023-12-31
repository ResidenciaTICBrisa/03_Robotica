# Guia de instalação do Choregraphe 2.1.4 (NAO v4)
---

## O que é o Choregraphe?

<div align=center>
<img src='../../overrides/assets/icons/choregraphe.png'/>
</div>

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

Para baixar o Choregraphe 2.1.4, acesse o [site da Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares).

Desça até o sub-menu Choregraphe, e na seção do **LINUX**, clique em `Former versions`.

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-1.jpeg'>
</div>

Na página que se abre, selecione o **setup** do Choregraphe na versão 2.1.4 (versão usada com o NAO v4).

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-2.jpg'>
</div>

O download será iniciado.

## Instalação

- Com o navegador de arquivos do Ubuntu, navegue até o diretório onde o setup baixado se encontra.

- Clique no arquivo de setup com o botão direito do mouse, vá em `propriedades` e selecione a aba `permissões`.

- Marque a caixa `Permitir a execução desse arquivo como um programa`.

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-3.jpg'>
</div>

- No terminal, abra o diretório onde o setup foi baixado.

- Execute o setup com o seguinte código (supondo que o nome do arquivo baixado seja "choregraphe-suite-2.1.4.13-linux64-setup.run"):

```
sudo ./choregraphe-suite-2.1.4.13-linux64-setup.run
```
<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-4.jpg'>
</div>

No wizard que se abre, aceite as permissões, selecione a opção **Quick install** e, quando for pedida a _license key_, insira o seguinte código:

> 654e-4564-153c-6518-2f44-7562-206e-4c60-5f47-5f45

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-5.jpg'>
</div>

- Deixe marcada a opção de iniciar (launch) o Choregraphe para testar se a instalação foi feita com sucesso e clique em `Finish`.

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-6.jpg'>
</div>

> Obs.: Como alternativa ao processo de instalação manual, pode-se executar o seguinte código:

```
sudo ./choregraphe-suite-2.1.4.13-linux64-setup.run --mode unattended --installdir '/my/destination_directory' --licenseKeyMode licenseKey --licenseKey '654e-4564-153c-6518-2f44-7562-206e-4c60-5f47-5f45'
```

## Execução do programa

**Executando o Choregraphe 2.1.4** 

Para executar o Choregraphe 2.1.4, existem duas maneiras diferentes.

1. Pelo ícone da área de trabalho

> Clique duas vezes no ícone do Choregraphe.

2. Pelo terminal

> Execute o seguinte código: `"/opt/Aldebaran Robotics/Choregraphe Suite 2.1/bin/choregraphe_launcher"` (com as aspas).

Caso a seguinte janela se abra, **parabéns**! Você **instalou o Choregraphe 2.1.4 com sucesso.**

<div align=center>
<img src='../../overrides/assets/images/choregraphe_v4-7.jpg'>
</div>