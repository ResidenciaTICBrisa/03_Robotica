# Navegando pelo diretório de scripts

O diretório de scripts contém a maior parte do projeto. Ele é composto pelos
scripts usados para gerar as máquinas virtuais (VMs) do NAOv4 e do NAOv6, e
pelos scripts usados para compilar o ROS1 e ROS2, bem como a documentação do
projeto, que é copiada para o diretório `docs` através de *links* simbólicos
gerados pelo script localizado em `03_Robotica/docs/mkdocs-kludge.sh`.

## O conteúdo dos diretórios

Segue abaixo o conteúdo de cada um dos diretórios e uma breve explicação sobre
cada um deles. Os níveis dos tópicos indicam os subdiretórios dentro de um
diretório.

- `ros1`: contém os scripts e a documentação que lidam com a compilação ou
instalação do ROS1 Noetic.
- `ros2`: contém os scripts e a documentação que se referem a compilação ou
instalação do ROS2 Humble.
- `vms`: contém os diretórios referentes às máquinas virtuais do NAOv4 e do
NAOv6:
    - `ubuntu-14`: contém os scripts e a documentação da máquina virtual do
    NAOv4.
    - `ubuntu-16`: contém os scripts e a documentação da máquina virtual do
    NAOv6.
