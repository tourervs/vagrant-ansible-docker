Vagrant.configure("2") do |config|
  config.vm.define "pureftpd_by_vagrant" do |pureftpd_by_vagrant|
    pureftpd_by_vagrant.vm.hostname    = "ftpserver"
    pureftpd_by_vagrant.ssh.username   = "root"
    pureftpd_by_vagrant.ssh.password   = "pureftpd123"
    pureftpd_by_vagrant.ssh.insert_key =  true
    pureftpd_by_vagrant.vm.provider "docker" do |d|
      d.build_dir = "."
      d.has_ssh     = true
    end
    pureftpd_by_vagrant.vm.provision :shell, path: "pure_ftpd_build.sh",run:"once"
    pureftpd_by_vagrant.vm.provision :shell, inline: "/usr/sbin/pure-ftpd /etc/pure-ftpd.conf",run:"once"
  end
  config.vm.define "pureftpd_by_ansible" do |pureftpd_by_ansible|
    pureftpd_by_ansible.vm.hostname    = "ftpserver"
    pureftpd_by_ansible.ssh.username   = "root"
    pureftpd_by_ansible.ssh.password   = "pureftpd123"
    pureftpd_by_ansible.ssh.insert_key =  true
    pureftpd_by_ansible.vm.provider "docker" do |d|
      d.build_dir = "."
      d.has_ssh     = true
    end
    # pureftpd_by_ansible.vm.provision :shell, path: "pure_ftpd_build.sh",run:"always"
    pureftpd_by_ansible.vm.provision :shell, path: "install_ansible.sh", run:"once"
    pureftpd_by_ansible.vm.provision "file", source: "./pureftpd-playbook.yml", destination: "/var/pureftpd-playbook.yml",run:"once"
    pureftpd_by_ansible.vm.provision :shell, inline: "ansible-playbook -s /var/pureftpd-playbook.yml",run:"once" 
    pureftpd_by_ansible.vm.provision :shell, inline: "/usr/sbin/pure-ftpd /etc/pure-ftpd.conf",run:"once"
  end
end
