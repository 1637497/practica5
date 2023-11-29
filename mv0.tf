resource "opennebula_virtual_machine" "example" {
  count = 2

  name        = "virtual-machine-0"
  description = "VM"
  cpu         = 1
  vcpu        = 1
  memory      = 1024
  group       = "terraform"
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
    image_id = opennebula_image.example.id
    size     = 10000
    target   = "vda"
    driver   = "qcow2"
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
