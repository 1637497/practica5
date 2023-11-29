resource "opennebula_virtual_machine" "default" {
  count = 2

  name        = "virtual-machine-${count.index}"
  description = "VM"
  cpu         = 0.5
  vcpu        = 2
  memory      = 1024
  permissions = "600"

  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "es"
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = data.opennebula_image.p5.id
    size     = 20000
    target   = "vda"
    driver   = "qcow2"
  }

  nic {
    model           = "virtio"
    network_id      = data.opennebula_virtual_network.net.id
    security_groups = [data.opennebula_security_group.sec.id]
  }

  template_id = data.opennebula_template.temp.id
  
}

data "opennebula_image" "p5"{
  name = "Ubuntu22.04+openssh-server"
}

data "opennebula_virtual_network" "net"{
  name = "Internet"
}
  
data "opennebula_security_group" "sec"{
  name = "default"
}  

data "opennebula_template" "temp"{
  name = "Ubu22.04v1.4-GIxPD"
}
