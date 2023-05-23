# Criação de um exemplo prático de automatização de deployment com Terraform 
Um guia para uma implementaçao de um exemplo prático de automatização com terraform.

## O que é Terraform ?
Terraform, da Hashicorp, permite criar, alterar e melhorar a infraestrutura de forma segura e previsível. É uma ferramenta Open Source que codifica APIs em arquivos de configuração declarativos que podem ser compartilhados entre membros de um time, tratados como código, editados, revisados e versionados. A principal ideia é além de manter a infraestrutura versionada, é trazer segurança e controle sobre todos os serviços que podemos utilizar em um provedor, tais como AWS, OpenStack, Azure, GCP, etc.
Uma vantagem do Terraform é que ele é MultiCloud, ou seja, conseguimos provisionar vários ambientes em diferentes provedores de nuvem usando uma única ferramenta.

## O que é Deploy ?

No contexto da programação, o termo "deploy" se refere ao processo de colocar uma aplicação em produção ou disponibilizá-la para uso. Isso inclui o provisionamento de servidores, a configuração do ambiente de hospedagem, a instalação de dependências, a configuração de banco de dados, entre outras tarefas necessárias para garantir que a aplicação esteja pronta e funcionando corretamente para os usuários finais. De mesmo modo, quando um sistema sofre alguma melhoria ou alteração em seu código-fonte, implementar essa alteração ao sistema que está no ar também é um tipo de deploy.

## O que é Docker ?
Docker é uma plataforma de código aberto que permite empacotar, distribuir e executar aplicativos em um ambiente isolado chamado de contêiner. Os contêineres Docker são leves, portáteis e autossuficientes, contendo tudo o que é necessário para executar um aplicativo, incluindo o código, as bibliotecas, as dependências e as configurações.

## Instalando o Docker
- Se usa Windows pode instalar o Docker via site [aqui](https://www.docker.com/);
- Se usa Linux (Ubuntu) pode fazer via comando:
 ``` sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin ```
 
 ## Instalando o Terraform
- Se usa Windows, pode instalar o Terraform via site [aqui](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform). Certifique-se de descompactar o arquivo binário e colocar o diretório onde o binário se encontra nas variáveis de ambiente do sistema (PATH). 
- Se usa Linux (Ubuntu), pode fazer via comando: ``` sudo apt install terraform ```
- Em seguida cheque a versão do terraform no seu sistema e veja se é a mais atual ```terraform --version```

## O que faremos ?
Rodaremos um jogo do Super Mario Bros no navegador, porém queremos que ele rode em um container, pois queremos uma aplicação em uma infraestrutura moderna e que possa ser capaz de rodar em qualquer local, seja em um servidor físico local, uma VM ou mesmo um provedor na nuvem. 

O jogo do Mario já existe e uma imagem para Docker já está disponível para o mesmo através do seguinte link: [Jogo Mario](https://hub.docker.com/r/pengbai/docker-supermario/)

### Crie um diretório com nome a sua escolha;
### Dentro do diretório crie um novo arquivo chamado ```mario.tf```.

A principio iremos inserir um ```resource```, sendo o mais básico em um código ou módulo Terraform, o resource, ou recurso. O Terraform suporta centenas de recursos diferentes, dentre eles o docker_image, que será o recurso de que precisaremos inicialmente.

O resource no Terraform é composta por 2 paramêtros, um deles é o tipo e o outro é o nome para este resource.

Inciialmente utilizaremos o resource ``docker_image`` que serve para baixar a imagem do nosso jogo.

- A documentação do Terraform é excelente e lista todos os resources suportados, bem como todos os atributos suportados por cada resource.

No arquivo mario.tf insira o seguinte código inicialmente:

``` terraform
# Baixa a imagem do Projeto Docker-SuperMario
resource "docker_image" "image_teste" {
  name = "pengbai/docker-supermario:latest"
}
```

Agora, vamos adicionar mais um resource em nosso código, desta vez um resource de tipo docker_container. Como o nome já diz, este resource lida com o container em si, e não mais apenas com a imagem.
- Dentro do bloco, listaremos os atributos dele, o primeiro atributo seria o ```image```  nele utilizaremos nossa primeira interpolação, onde reutilizaremos valores de outra parte de nosso código como se fossem variáveis. 

Em nosso resource anterior, docker_image, demos um nome image_teste que será utilizado agora. Incluiremos também a tag image_id, pois, conforme vamos ver na saída de nosso comando terraform show, esta foi a tag utilizada pelo terraform para identificar o último status daquele resource.

- O segundo atributo no docker_ontainer seria o name, que chamaremos de supermario.
- Por fim, indicamos as portas, pois toda aplicação necessita de portas para funcionar, aqui listamos 2 portas, a ```intern``` que é utilizada internamente no container, e a ```extern``` que é utilizada pelo Docker, para acessarmos a aplicação localmente.

Logo o código agora fica assim:

``` terraform
# Baixa a imagem do Projeto Docker-SuperMario
resource "docker_image" "image_teste" {
  name = "pengbai/docker-supermario:latest"
}

# Inicia o Container
resource "docker_container" "image_teste" {
  image = "${docker_image.image_teste.image_id}"
  name  = "supermario"
  ports {
    internal = "8080"
    external = "80"
  }
}
```
Por fim, adicionaremos providers, que são necessários para que o programa funcione, que são referências aos "provedores" no caso aqui localhost e ao docker que estamos utilizando.
Portanto, o código final é este:
``` terraform
provider "local" {}

# Baixa a imagem do Projeto Docker-SuperMario
resource "docker_image" "image_teste" {
  name = "pengbai/docker-supermario:latest"
}

# Inicia o Container
resource "docker_container" "image_teste" {
  image = "${docker_image.image_teste.image_id}"
  name  = "supermario"
  ports {
    internal = "8080"
    external = "80"
  }
}

#Seta os provedores para não dar erro an hora do terraform init/plan
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 0.13"
}
```

### Agora, no CMD ou Terminal, execute o seguinte comando: ```terraform init```.
 - Este comando inicia nosso ambiente e baixa os plugins necessários para nosso projeto.
 - O retorno gerado pelo comando, deve ser algo parecido com o que obtivemos abaixo:
 ![1](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/6884d526-f6e6-443a-b66d-687f4686fa6b)
 
O próximo passo será executar o planejamento do código. Ao rodar o planejamento o Terraform listará exatamente tudo o que fará caso o código seja de fato executado. 

### - No CMD ou Terminal execute: ```terraform plan```. 
![2](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/4597e1f8-2a23-44f3-93eb-bbaaf59d9ecf)
![3](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/2921788e-fef2-4086-bca7-4a784e79abe2)

Caso você tenha recebido um retorno similar a este, significa que tudo parece correto. Ao fim da linha, ele mostra quantos itens que serão adicionados, alterados ou destruídos.

### Após o sucesso do comando anterior, no CMD ou Terminal, execute o seguinte: ```terraform apply```.

![4](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/d512a4b5-ba72-4a3d-b28d-4ab8c24a6ab5)

O Terraform avaliou o código e nos indicou o que será realizado, perguntando ao final se queremos ou não seguir com a execução. 

Caso tudo nos pareça correto, basta digitar ```yes```  e pressionar Enter novamente para que ele siga com a execução de fato.

![5](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/1fc1048d-9382-4d15-8aac-7af748dc839c)

### Curiosidade
O Terraform também nos permite saber o que estamos utilizando em termos de resources através do comando ```terraform show```.

### Execute agora ````docker ps```` para ver os containers que estão rodando neste momento:
![6](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/6e3561d9-c160-41fb-9d03-36c394fbcba1)

### Por fim, abra o navegador e acesse o seguinte endereço: ````localhost:80````.

![7](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/dde221f9-bcaf-4eb4-ba8b-689aeb772cf7)

### Curiosidade 2

O Terraform também nos permite destruir a nossa infraestrutura com o comando ```terraform destroy```. Da mesma forma que o apply, o comando destroy também lhe dará uma prévia de o que será destruído e lhe pedirá par aconfirmar com um yes ou no:

![8](https://github.com/RafaelAugustoo/les-trab1/assets/55588156/fb78323d-2fe4-41b6-a71d-c8e890fda2d3)

#### Agora é a sua vez, testando os conceitos basicos de deployment com terraform, rode o jogo do Mário no seu dispositivo, e no fim se divirta :)

## Referências 

- [Automatize a sua estrutura com Terraform](https://medium.com/vindi/automatizando-a-infraestrutura-com-terraform-7cbd4b15ac1)
- [Terraform.io](https://www.terraform.io/)
- [Docker](https://www.docker.com/)
- [Infraestrutura como Código com Terraform](https://blog.marcelocavalcante.net/infraestrutura-como-c%C3%B3digo-com-terraform/)
- [Terraform: Variáveis e Outputs](https://blog.marcelocavalcante.net/terraform-vari%C3%A1veis-e-outputs/)
- [Introdução ao Terraform](https://blog.marcelocavalcante.net/introdu%C3%A7%C3%A3o-ao-terraform/)

## Créditos 
Esse repositório constitui o 1º projeto da disciplina Laboratório de Engenharia de Software 1 do CEFET-MG.

- MATEUS LEMOS DE FREITAS BARBOSA  - 20193017591
- RAFAEL AUGUSTO DE SOUZA - 20193025261
- TÚLIO FERREIRA HORTA - 20193017205 


