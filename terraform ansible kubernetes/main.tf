provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_core_instance" "master" {
  compartment_id = var.compartment_id
  availability_domain = var.availability_domain
  shape = "VM.Standard2.1"
  display_name = "k8s-master"

  create_vnic_details {
    subnet_id = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    image_id = var.image_id
  }
}

resource "oci_core_instance" "worker" {
  compartment_id = var.compartment_id
  availability_domain = var.availability_domain
  shape = "VM.Standard2.1"
  display_name = "k8s-worker"

  create_vnic_details {
    subnet_id = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    image_id = var.image_id
  }
}

output "master_ip" {
  value = oci_core_instance.master.public_ip
}

output "worker_ip" {
  value = oci_core_instance.worker.public_ip
}
