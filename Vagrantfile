
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.name = "objects_devkit"

    v.memory = 8192
  end

  config.vm.synced_folder "../smartcosmos-vagrant-config", "/opt/cluster-config"

  config.vm.network(:forwarded_port, guest: 8888, host: 8888)
  config.vm.network(:forwarded_port, guest: 8761, host: 8761)
  # config.vm.network(:forwarded_port, guest: 3333, host: 3333)

  config.vm.provision :shell, inline: "apt-get update"

  config.vm.provision :docker do |d|
    d.build_image "/vagrant/docker/java", args: "-t smartcosmos/java"
    d.build_image "/vagrant/docker/service", args: "-t smartcosmos/service"
  end

  config.vm.provision :docker_compose, yml: ["/vagrant/docker-compose.yml"], rebuild: true, project_name: "devkit", run: "always"
end
