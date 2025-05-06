provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu_qcow2" {
  name   = "ubuntu-volume"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_domain" "ubuntu_vm" {
  name   = "test-vm"
  memory = var.ram_mb
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2.id
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
    type = "vnc"
    listen_type = "address"
    autoport = true
  }
}
