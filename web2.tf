resource "digitalocean_droplet" "web2" {
  image = "ubuntu-16-04-x64"
  name = "web2"
  region = "LON1"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    host = "${self.ipv4_address}"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)",
      "export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)",
      "echo Hello from Droplet $HOSTNAME, with IP Address: $PUBLIC_IPV4 > /var/www/html/index.nginx-debian"
    ]
  }
}
