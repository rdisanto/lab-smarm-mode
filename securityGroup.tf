# SecurityGroup
resource "openstack_compute_secgroup_v2" "lab_swarm_mode" {
    name = "lab_swarm_mode"
    description = "default swarm security group"

    rule {
        from_port = 22
        to_port = 22
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
    rule {
        from_port = 2377
        to_port = 2377
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
    rule {
        from_port = 7946
        to_port = 7946
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
    rule {
        from_port = 7946
        to_port = 7946
        ip_protocol = "udp"
        cidr = "0.0.0.0/0"
    }
    rule {
        from_port = 4789
        to_port = 4789
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
}