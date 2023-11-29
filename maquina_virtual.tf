resource "opennebula_virtual_machine" "example" {
  count = 2

  name        = "virtual-machine-${count.index}"
  description = "VM"
  cpu         = 0.5
  vcpu        = 2
  memory      = 1024
  permissions = "600"

  context = {
    NETWORK      = "YES"
    HOSTNAME     = "$NAME"
    START_SCRIPT = "yum upgrade"
  }

  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "fr"
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = data.ON_image.p5.id
    size     = 20000
    target   = "vda"
    driver   = "qcow2"
  }

  data "ON_image" "p5"{
    name = "Ubuntu22.04+openssh-server"
  }
  
  on_disk_change = "RECREATE"

  nic {
    model           = "virtio"
    network_id      = var.vnetid
    security_groups = [opennebula_security_group.example.id]
  }

  vmgroup {
    vmgroup_id = 42
    role       = "vmgroup-role"
  }

  sched_requirements = "FREE_CPU > 60"

  tags = {
    environment = "example"
  }

  template_section {
   name = "example"
   elements = {
      key1 = "value1"
   }
  }
}
