#!/usr/bin/env python3

import json
import subprocess

def get_terraform_output():
    result = subprocess.run(["terraform", "output", "-json"], capture_output=True, text=True)
    return json.loads(result.stdout)

def generate_inventory(outputs):
    inventory = {
        "all": {
            "children": {
                "kubernetes": {
                    "children": ["master", "worker"]
                }
            }
        },
        "master": {
            "hosts": [outputs["master_ip"]["value"]]
        },
        "worker": {
            "hosts": [outputs["worker_ip"]["value"]]
        },
        "_meta": {
            "hostvars": {
                outputs["master_ip"]["value"]: {
                    "ansible_host": outputs["master_ip"]["value"],
                    "ansible_user": "your_ssh_user",
                    "ansible_ssh_private_key_file": "/path/to/your/private_key.pem"
                },
                outputs["worker_ip"]["value"]: {
                    "ansible_host": outputs["worker_ip"]["value"],
                    "ansible_user": "your_ssh_user",
                    "ansible_ssh_private_key_file": "/path/to/your/private_key.pem"
                }
            }
        }
    }
    return inventory

if __name__ == "__main__":
    terraform_outputs = get_terraform_output()
    inventory = generate_inventory(terraform_outputs)
    print(json.dumps(inventory, indent=2))
