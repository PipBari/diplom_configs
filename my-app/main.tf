# main.tf
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

resource "local_file" "hello_file_1" {
  filename = "file1.txt"
  content  = "Привет из первого ресурса"
}

resource "local_file" "hello_file_2" {
  filename = "file2.txt"
  content  = "Привет из второго ресурса"
}
