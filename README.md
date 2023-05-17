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
- Se usa Windows pode instalar o Docker via site [aqui](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform);
- Se usa Linux (Ubuntu) pode fazer via comando: ``` sudo apt install terraform ```
- Em seguida cheque a versão do terraform no seu sistema e veja se é a mais atual ```terraform --version```





