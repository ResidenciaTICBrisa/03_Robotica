# Instalação do NAO Flasher (NAO v4 e NAO v6)
---

O NAO Flasher é uma ferramenta que permite a realização de updates no sistema do NAO v4 e do NAO v6, além do reset de fábrica e outras possibilidades.

> Recomendação: usar no **Linux Ubuntu 16.04 (Xenial Xerus)**.

## Download

- Acesse o site da [Aldebaran Robotics](https://www.aldebaran.com/en/support/nao-6/downloads-softwares).

- Desça até o menu "NAO Flasher", e clique nele.

- Na aba "LINUX", clique no botão `NAO Flasher 2.1.0 - Setup`.

- O download do NAO Flasher será iniciado.

## Instalação e execução

O NAO Flasher baixado no site da Aldebaran Robotics vem em formato de binários, ou seja, não é necessária uma instalação usando um setup. Em outras palavras, basta executar o executável do NAO Flasher, através dos seguintes passos:

- Vá até a pasta onde o arquivo foi baixado.

- Clique sobre o arquivo _tar.gz_ com o botão direito e selecione `Extrair aqui`.

- Abra a pasta instalada, e dentro dela acesse a pasta `bin`, que deve conter um arquivo "Flasher".

- Clique sobre o arquivo "Flasher" com o botão direito e selecione `Propriedades`. Na aba `Permissões`, marque a caixa `Permitir execução do arquivo como um programa`.

- Para executar o arquivo, clique com o botão direito na pasta `bin` e selecione `Abrir no terminal`. Em seguida, digite o seguinte código:

```
sudo ./flasher
```

> Caso abra a interface do NAO Flasher, a instalação foi concluída com sucesso.