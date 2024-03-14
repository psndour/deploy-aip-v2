Vagrant.configure("2") do |config|
  (2..2).each do |i|
    config.vm.define "aip-sandbox" do |machine|
      config.vm.synced_folder "/Users/papesambandour/PC_CLOUD/FREE/PI-BCEAO/deploy-aip/certificats", "/certificats"
      machine.vm.box = "centos/7"
      machine.vm.network "private_network", virtualbox__intnet: "netfusion_mz", ip: "10.0.96.#{i}"
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      machine.vm.provision "shell", inline: <<-SHELL
       sudo mkdir -p /root/.ssh
       sudo chmod 700 /root/.ssh
       sudo echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
       sudo echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
       sudo chmod 600 /root/.ssh/authorized_keys
       # Configuration du nom d'hôte
       sudo hostnamectl set-hostname "pi-mz-#{i-1}"
       sudo echo "127.0.0.1 aip-sandbox" | sudo tee -a /etc/hosts
      SHELL
      machine.vm.provider "vmware_fusion" do |vm|
        vm.memory = "8096"
        vm.cpus = 6
      end
    end
  end
end

