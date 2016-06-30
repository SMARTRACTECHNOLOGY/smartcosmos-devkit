
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.name = "objects_devkit"
    v.memory = 8192
  end

  config.vm.network(:forwarded_port, guest: 8888, host: 8888)   # config-server
  config.vm.network(:forwarded_port, guest: 8761, host: 8761)   # eureka
  config.vm.network(:forwarded_port, guest: 9999, host: 9999)   # auth-server
  config.vm.network(:forwarded_port, guest: 8765, host: 8765)   # gateway
  config.vm.network(:forwarded_port, guest: 42000, host: 42000) # user-details-service
  config.vm.network(:forwarded_port, guest: 45336, host: 45336) # ext-things

  config.vm.provision :shell, inline: "apt-get update"

  config.vm.provision :docker do |d|
    d.build_image "/vagrant/docker/java", args: "-t smartcosmos/java"
    d.build_image "/vagrant/docker/service", args: "-t smartcosmos/service"
  end

  config.vm.provision :docker_compose, yml: ["/vagrant/docker-compose.yml"], rebuild: true, project_name: "devkit", run: "always"
end
