### **Running immich-manage.yaml Playbook**

#### **Start Immich**

`ansible-playbook -i hosts.yaml playbooks/immich-manage.yaml --ask-vault-pass`

**Stop Immich**

`ansible-playbook -i hosts.yaml playbooks/immich-manage.yaml --ask-vault-pass -e "stop_service=true"`

**Update Immich (Pull Latest Images & Restart)**

`ansible-playbook -i hosts.yaml playbooks/immich-manage.yaml --ask-vault-pass -e "update_service=true"`
