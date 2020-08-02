provider "digitalocean" {
  token = var.do_token
}

# provider "docker" {
#   host = "ssh://root@${digitalocean_droplet.web.ipv4_address}"
# }

resource "digitalocean_droplet" "web" {
  image              = "ubuntu-18-04-x64"
  name               = "web"
  region             = "lon1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [var.ssh_fingerprint]
}

# resource "docker_container" "container" {
#   image = "${docker_image.ubuntu.name}"
#   name  = "container"
# }

# resource "docker_image" "ubuntu" {
#   name = "ubuntu:latest"
# }