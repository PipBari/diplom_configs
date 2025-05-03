terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

resource "local_file" "hello_file" {
  filename = "bb.txt"
  content  = "Пока, Terraform!!"
}
