system('./pre-up.sh')
Vagrant.configure("2") do |config|
  config.vm.define "pureftpd" do |pureftpd|
    pureftpd.vm.hostname    = "ftpserver"
    pureftpd.ssh.username   = "root"
    pureftpd.ssh.password   = "pureftpd123"
    pureftpd.ssh.insert_key =  true
    pureftpd.vm.provider "docker" do |d|
      d.build_dir = "."
      d.has_ssh     = true
    end
    pureftpd.vm.provision :shell, path: "pure_ftpd_build.sh"
  end
end
