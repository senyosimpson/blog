provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web" {
  image              = "ubuntu-18-04-x64"
  name               = "web"
  region             = "lon1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [var.ssh_fingerprint]
}
