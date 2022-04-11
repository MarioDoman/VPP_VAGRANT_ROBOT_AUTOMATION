# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-18.04"
  config.vm.box_check_update = false

  vmcpu=(ENV['VPP_VAGRANT_VMCPU'] || 2)
  vmram=(ENV['VPP_VAGRANT_VMRAM'] || 4096)

  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "1.1.1.10", virtualbox__intnet: true
  config.vm.network "private_network", ip: "1.1.1.11", virtualbox__intnet: true
  # config.vm.network "public_network", ip: "192.168.1.17", bridge: "Realtek USB GbE Family Controller #3"
  config.vm.network "public_network", type: "dhcp"

 
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.memory = "#{vmram}"
      vb.cpus = "#{vmcpu}"
      #support for the SSE4.x instruction is required in some versions of VB.
      vb.customize ["setextradata", :id, "VBoxInternal/CPUM/SSE4.1", "1"]
      vb.customize ["setextradata", :id, "VBoxInternal/CPUM/SSE4.2", "1"]
      
  end

  config.vm.provision :shell, privileged: false, run: "always", inline: %(
    echo "deb \[trusted=yes\] https:\/\/packagecloud.io\/fdio\/release\/ubuntu bionic main" \| sudo tee "/etc/apt/sources.list.d/99fd.io.list"
    sudo curl -L https://packagecloud.io/fdio/release/gpgkey | sudo apt-key add -
    sudo apt-get update
    sudo apt-get --yes install vpp vpp-plugin-core vpp-plugin-dpdk iperf
    sudo ifconfig eth1 172.168.1.5/24
    sudo ifconfig eth2 down
    sudo sed -i 's/# dpdk/dpdk/' /etc/vpp/startup.conf
    sudo sed -i 's/# dev 0000:02:00.0/dev 0000:00:09.0/' /etc/vpp/startup.conf 
    sudo service vpp restart
    sleep 10
    sudo vppctl set int ip address GigabitEthernet0/9/0 172.168.1.6/24
    sudo vppctl set interface state GigabitEthernet0/9/0 up    
    ping -c 15 172.168.1.6
    iperf -D -s
    ifconfig eth3 | grep "inet "
    )
end