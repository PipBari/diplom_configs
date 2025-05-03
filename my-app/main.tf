terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "file1" {
  filename = "${path.module}/file1.txt"
  content  = "Это файл 1"
}

resource "local_file" "file2" {
  filename = "${path.module}/file2.txt"
  content  = "Это файл 2"
}

resource "local_file" "file3" {
  filename = "${path.module}/file3.txt"
  content  = "Это файл 3"
}
