resource "virtual_machine" "overkill" {
  name   = "super-heavy"
  memory = 4000000
  cpu    = 32
  disk   = 100
}
