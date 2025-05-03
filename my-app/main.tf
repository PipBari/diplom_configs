provider_installation {
  filesystem_mirror {
    path    = "/usr/local/share/terraform/providers"
    include = ["hashicorp/local"]
  }
  direct {
    exclude = ["hashicorp/local"]
  }
}
