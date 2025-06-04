variable "ram_mb" {
  description = "Объем оперативной памяти в мегабайтах"
  type        = number
  default     = 64
}

resource "local_file" "ram_info" {
  content  = "Выделено памяти: ${var.ram_mb} MB\n"
  filename = "${path.module}/ram_info.txt"
}
