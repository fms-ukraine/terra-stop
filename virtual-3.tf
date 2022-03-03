resource "digitalocean_droplet" "virtual-3" {
  image = "ubuntu-20-04-x64"
  name = "virtual-3"
  region = "ams3"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
    provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install bombardier and start
      "apt-get update",
      "apt-get install -y git curl docker docker.io",
      "git clone https://github.com/fms-ukraine/stop-war.git",
      "cp /root/stop-war/app/docker-compose /usr/local/bin/",
      "chmod +x /usr/local/bin/docker-compose",
      "docker-compose -f /root/stop-war/docker-compose.yaml up -d --build"
    ]
  }
}
