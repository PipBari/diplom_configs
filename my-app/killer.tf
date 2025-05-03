resource "virtual_machine" "overkill" {
  name   = "super-heavy"
  memory = 40000
  cpu    = 32
  disk   = 100
}
