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
}