terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu_volume" {
  name   = "ubuntu-min"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/minimal/releases/focal/release/ubuntu-20.04-minimal-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_domain" "ubuntu_vm" {
  name   = "ubuntu-vm"
  memory = 512
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu_volume.id
  }

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  boot_device {
    dev = ["hd"]
  }
}
