Vagrant.configure("2") do |config|
    if Vagrant.has_plugin?("vagrant-destroy-on-finish")
        config.destroy_on_finish.enabled = true
    end

    # Config for VirtualBox
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.linked_clone = true
      vb.cpus = 1
      vb.check_guest_additions = false
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"] # Allows promiscuous mode
    end

    # We set custom keys for the Vagrant main process
    config.vm.provision "shell", privileged: false, inline: <<-SCRIPT
        cp /vagrant/vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
        cp /vagrant/vagrant/id_rsa /home/vagrant/.ssh/id_rsa
        cat /vagrant/vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*
        chmod 600 /home/vagrant/.ssh/id_rsa*
    SCRIPT

    ## Servers to set up
    servers = [
        { name: "vagrant-manager-1", box: "ubuntu/jammy64", ip: "192.168.56.2" },
        { name: "vagrant-wazuh-1", box: "ubuntu/jammy64", ip: "192.168.56.10" },
        { name: "vagrant-wazuh-indexer-1", box: "ubuntu/jammy64", ip: "192.168.56.11" },
        { name: "vagrant-kibana-1", box: "ubuntu/jammy64", ip: "192.168.56.12" }
    ]

    # Tasks to execute
    tasks = []

    # Server setup
    servers.each do |spec|
        config.vm.define spec[:name] do |node|
            node.vm.box = spec[:box]
            node.vm.hostname = spec[:name]
            node.vm.network "private_network", ip: "#{spec[:ip]}"
            
            # Task execution (from manager node)
            if spec[:name] == "vagrant-manager-1"
                tasks.each do |task|
                    node.vm.provision task, type: "ansible" do |ansible|
                        ansible.playbook = "tests/#{task}.yml"
                        ansible.inventory_path = "inventories/hosts.yml"
                        ansible.limit = "all"
                        ansible.raw_ssh_args = [
                            '-o ControlMaster=auto',
                            '-o ControlPersist=300s',
                            '-o PreferredAuthentications=publickey',
                            '-o StrictHostKeyChecking=no',
                            '-o UserKnownHostsFile=/dev/null',
                            "-o IdentityFile=./vagrant/id_rsa"
                        ]
                    end
                end
            end
        end
    end
end