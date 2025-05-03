provider "local" {}

resource "null_resource" "test_vm" {
  triggers = {
    cpu = var.cpu
    ram = var.ram
  }

  provisioner "local-exec" {
    command = "echo Creating VM with ${var.cpu} vCPU and ${var.ram} MB RAM"
  }
}
