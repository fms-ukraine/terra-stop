resource "digitalocean_droplet" "virtual-7" {
  image = "ubuntu-20-04-x64"
  name = "virtual-7"
  region = "ams3"
  size = "s-2vcpu-2gb"
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
      "sleep 20",
      "apt-get update",
      "apt-get install -y git curl docker docker.io",
      "git clone https://github.com/fms-ukraine/stop-war.git",
      "rm -rf /usr/local/bin/docker-compose && rm -rf /usr/bin/docker-compose",
      "wget https://github.com/fms-ukraine/stop-war/raw/master/app/docker-compose -P /usr/local/bin/ && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose && chmod +x /usr/bin/docker-compose",
      "cd /root/stop-war && docker-compose up -d --build"
    ]
  }
}
