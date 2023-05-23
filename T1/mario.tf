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
