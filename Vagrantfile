
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network(:forwarded_port, guest: 8888, host: 8888)
  # config.vm.network(:forwarded_port, guest: 3333, host: 3333)

  config.vm.provision :shell, inline: "apt-get update"

  config.vm.provision :docker do |d|
    d.build_image "/vagrant", args: "-t smartcosmos/java"
  end

  config.vm.provision :docker_compose, yml: ["/vagrant/docker-compose.yml"], rebuild: true, project_name: "devkit", run: "always"
end
