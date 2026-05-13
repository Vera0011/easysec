Vagrant.configure("2") do |config|
    if Vagrant.has_plugin?("vagrant-destroy-on-finish")
        config.destroy_on_finish.enabled = true
    end

    # Config for VirtualBox
    config.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.check_guest_additions = false
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"] # Allows promiscuous mode
    end

    # Generate RSA keys on the host before provisioning
    config.trigger.before :up do |trigger|
        trigger.name = "Generate RSA keys"
        trigger.run = { path: "./scripts/create_keys.sh" }
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
    ALL_SERVERS = [
        { 
            name: "vagrant-manager-1",
            box: "ubuntu/jammy64",
            ip: "192.168.56.2",
            memory: "512",
            cpus: 1,
            boot_timeout: 600
        },
        { 
            name: "vagrant-kali-1",
            box: "kalilinux/rolling",
            ip: "192.168.56.3",
            memory: "2048",
            cpus: 2,
            boot_timeout: 600
        },
        { 
            name: "vagrant-ubuntu-1",
            box: "ubuntu/jammy64",
            ip: "192.168.56.4",
            memory: "2048",
            cpus: 2,
            boot_timeout: 600
        },
        {
            name: "vagrant-keycloak-1",
            box: "ubuntu/jammy64",
            ip: "192.168.56.5",
            memory: "2048",
            cpus: 2,
            boot_timeout: 600
        },
        {
            name: "vagrant-postgresql-1",
            box: "ubuntu/jammy64",
            ip: "192.168.56.6",
            memory: "2048",
            cpus: 2,
            boot_timeout: 600
        }
    ]

    # Tasks to execute - Single playbooks and complete workflows
    ALL_MODULES = ["proxychains", "lynis", "grype", "syft", "grant", "ssl", "postgresql"]
    ALL_WORKFLOWS = ["anchore", "keycloak"]
    MAPPING_SERVERS = {
        "proxychains" => ["vagrant-kali-1"],
        "lynis"       => ["vagrant-ubuntu-1"],
        "grype"       => ["vagrant-ubuntu-1"],
        "syft"        => ["vagrant-ubuntu-1"],
        "grant"       => ["vagrant-ubuntu-1"],
        "ssl"         => ["vagrant-ubuntu-1"],
        "postgresql"  => ["vagrant-postgresql-1"],
        "keycloak"    => ["vagrant-keycloak-1", "vagrant-postgresql-1"],
        "anchore"     => ["vagrant-ubuntu-1"]
    }

    # Updates list if requested by the user
    modules = ENV.fetch("CUSTOM_MODULES", "").split(",").map(&:strip).reject(&:empty?)
    playbooks = modules.empty? ? ALL_MODULES : ALL_MODULES & modules
    workflows = modules.empty? ? ALL_WORKFLOWS : ALL_WORKFLOWS & modules
    
    # Only load required servers to speed-up setup
    required_servers = if modules.empty?
        ALL_SERVERS.map { |s| s[:name] }
    else
        modules.flat_map { |mod| MAPPING_SERVERS.fetch(mod, []) }.uniq
    end

    # Always include manager
    required_servers << "vagrant-manager-1"
    required_servers.uniq!

    servers = ALL_SERVERS.select { |s| required_servers.include?(s[:name]) }

    puts "\n─────────────────────────────────────"
    puts "  EasySec - Loading environment"
    puts "─────────────────────────────────────"
    puts "  Modules  : #{modules.empty? ? "all" : modules.join(', ')}"
    puts "  Servers  : #{servers.map { |s| s[:name] }.join(', ')}"
    puts "─────────────────────────────────────\n"

    # Server setup
    servers.each do |spec|
        config.vm.define spec[:name] do |node|
            node.vm.box = spec[:box]
            node.vm.hostname = spec[:name]
            node.vm.network "private_network", ip: "#{spec[:ip]}"
            node.vm.boot_timeout = spec[:boot_timeout]
            
            # Override provider settings per node if specified
            if spec[:memory] || spec[:cpus]
                node.vm.provider "virtualbox" do |vb|
                    vb.memory = spec[:memory] if spec[:memory]
                    vb.cpus = spec[:cpus] if spec[:cpus]
                end
            end
            
            # Playbooks and workflows execution (from manager node)
            if spec[:name] == "vagrant-manager-1"
                playbooks.each do |task|
                    node.vm.provision task, type: "ansible" do |ansible|
                        ansible.playbook = "playbooks/#{task}.yml"
                        ansible.inventory_path = "inventory/hosts.yml"
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

                workflows.each do |task|
                    node.vm.provision task, type: "ansible" do |ansible|
                        ansible.playbook = "workflows/#{task}.yml"
                        ansible.inventory_path = "inventory/hosts.yml"
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