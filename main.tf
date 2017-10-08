# vps
resource "openstack_compute_instance_v2" "vps" {
    count = 3

    name = "vps-swarm_mode-${(count.index)+1}"
    image_name = "Debian 9" # Image name
    flavor_name = "s1-2" # Type Machine Name_keypair
    key_pair = "${openstack_compute_keypair_v2.test_keypair.name}"
    network {
        name = "Ext-Net" # Add public network
    }
    security_groups = ["${openstack_compute_secgroup_v2.lab_swarm_mode.id}"]
}

# Import of team ssh public keys in OpenStack
resource "openstack_compute_keypair_v2" "test_keypair" {
    provider = "openstack.ovh" # Provider's name in provider.tf
    name = "test_keypair" # Name of ssh key
    #https://github.com/rdisanto/public-keys/blob/patch-2/authorized_keys
    public_key = "${file("~/.ssh/id_rsa.pub")}" # Path to ssh public keys
}


resource "null_resource" "ansible-provision"{
    count = 1

    provisioner "local-exec" {
        command = "echo \"[swarm-master]\" > swarm-inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${format("%s ansible_ssh_user=%s", openstack_compute_instance_v2.vps.0.access_ip_v4, var.ssh_user)}\" >> swarm-inventory"
    }

    provisioner "local-exec" {
        command = "echo \"[swarm-nodes]\" >> swarm-inventory"
    }

    provisioner "local-exec" {
        command = "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", openstack_compute_instance_v2.vps.*.access_ip_v4, var.ssh_user))}\" >> swarm-inventory"
    }

    provisioner "local-exec" {
        connection {
            type = "ssh"
            user = "${(var.ssh_user)}"
            private_key = "${file("~/.ssh/id_rsa")}"
        }
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key=~/.ssh/id_rsa -u ${(var.ssh_user)} -i swarm-inventory ansible/provision.yml"
    }
}