IMAGE = "bento/ubuntu-16.04"
NODES =  2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
    config.vm.box_check_update = false
        v.memory = 1024
        v.cpus = 2
    end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE

        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "k8s-master"

        master.vm.provider "virtualbox" do |v|
        master.vm.box_check_update = false
            v.memory = 4096
            v.cpus = 3
        end

        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "setup-kubernetes/kube-master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.50.10",
            }
        end
    end

    (1..NODES).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "setup-kubernetes/kube-node-playbook.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.50.#{i + 10}",
            }
        end
    end
end

    config.vm.define "jenkins-master" do |jenkins|
        jenkins.vm.box = IMAGE
        jenkins.vm.network "private_network", ip: "192.168.50.100"
        jenkins.vm.hostname = "jenkins-master"
        jenkins.vm.provision "ansible" do |ansible|
            ansible.playbook = "setup-jenkins/jenkins-playbook.yml"
        end
    end    
end
