# Exemplos de programação em C++ do NAOqi 2.1

Esses exemplos podem ser usados para aprender a codificar os comportamentos mais
básicos usando a NAOqi 2.1, uma interface de programação de aplicações (API)
implementada em C++98.

A API NAOqi 2.1 suporta apenas C++98, mesmo no caso de serem usados compiladores
mais novos. Todos os exemplos foram compilados usando o GCC 4.8.2 e o cmake
2.8.12 disponibilizados nos repositórios do Ubuntu 14, denominado *trusty*, e
foram testados em um robô NAOH25V40, um modelo do NAO4 com um corpo completo
incluindo os sensores de carga resistivos (FSRs) nos pés.

Os seguintes exemplos estão incluídos neste diretório:

- `01.hello-world-legacy`: o exemplo *hello world* mais simples. Usa métodos
legados que permitem chamar um módulo sem um intermediário (*broker*) explícito.
O robô usará seu módulo de texto para voz, denominado `ALTextToSpeech`, para
dizer a clássica frase "Hello, World!".
- `02.hello-world`: um exemplo *hello world* com um *broker* explícito. Esse é o
modo recomendado de se chamar qualquer módulo disponibilizado pela API.
- `03.hello-world-module`: umj exemplo *hello world* implementado como um módulo
NAOqi2, usando um *broker* em seu construtor.
- `04.using-events`: um exemplo que explica como escrever um módulo que reage a
eventos postados por outros módulos no `ALMemory` usando funções *callback* e
uma implementação de um *mutex* da própria API. Todos os eventos que forem
assinados pelo módulo terão sua chave, valor e mensagem impressos na tela.
- `05.riseup`: um exemplo que ensina como modificar a postura do NAO e permitir
que todos os motores sejam energizados para "acordá-lo". Também há a
exemplificação de várias funções úteis, como a otimização de corrente, proteção
contra colisões envolvendo objetos externos e o próprio corpo do robô, e a pose
defensiva para proteger o NAO de quedas frontais. O robô irá reagir aos botões
táteis em sua cabeça:
    - o botão frontal acordará o NAO, mudando a sua postura, fazendo-o se
    levantar e energizar todos seus motores para assim permanecer;
    - o botão do meio fará o NAO descansar, ativando a postura de agachamento e
    desligando todos seus motores;
    - o botão traseiro ativa uma animação de respiração enquanto o NAO estiver
    acordado.
- `06.walking`: esse exemplo usa uma máquina de estados finita para fazer o NAO
acordar e andar para a esquerda e para frente usando o seu caminhar padrão. O
robô irá se mover quando o botão frontal for ativado, e parará quando o botão do
meio for tocado. O exemplo pode não funcionar em robôs com problemas nos
atuadores das juntas ou nos sensores dos pés.
- `07.walking-custom`: esse exemplo parece-se com o anterior, mas faz o NAO
andar usando um caminhar personalizado. Ele também tolera robôs com problemas
nas juntas ou nos FSRs. Isso é feito checando se o robô conseguiu aproximar o
suficiente da postura configurada. Também é usada as abstrações que a NAOqi
fornece para o uso das funções POSIX `sleep` e `msleep`.

## Como encontrar os exemplos

1. Vá para [Robo Connection repository](https://github.com/ResidenciaTICBrisa/03_Robotica).
2. Entre no diretório `03_Robotica/nao-programs/naoqi-2.1/cpp/`.
3. Todos os exemplos devem estar listados e separados em seus diretórios
específicos.

## Como executar os exemplos

1. Copie o diretório desejado para o seu espaço de trabalho `qibuild`. Caso
tenha usado nossos scripts, ele estará em `/home/softex/NAO4/workspace`.
2. Mude o diretório atual para aquele com o exemplo que deseja executar. Para
isso, use o comando `cd`.
3. Configure o *toolchain* do projeto. Se usou nossos scripts, o comando
`qibuild configure -c "$NAOQI_CPP_QIBUILD_CONFIG"` será suficiente.
4. Compile o projeto com `qibuild make` ou `qibuild make --rebuild`.
5. Execute o programa compilado. Ele normalmente está em uma estrutura de
diretórios parecida com `build-${NAOQI_CPP_QIBUILD_CONFIG}/sdk/bin`. A maioria
dos exemplos usa argumentos para configurar um *broker*, e a ordem destes
normalmente é o nome do *broker* do NAO ou o seu endereço IPv4, seguido da porta
em que ele escuta as conexões, usualmente 9559.