### **Running traefik-manage.yaml Playbook**

#### **Start Traefik**

`ansible-playbook -i hosts.yaml playbooks/traefik-manage.yaml --ask-vault-pass`

**Stop Traefik**

`ansible-playbook -i hosts.yaml playbooks/traefik-manage.yaml --ask-vault-pass -e "stop_service=true"`

**Update Traefik (Pull Latest Images & Restart)**

`ansible-playbook -i hosts.yaml playbooks/traefik-manage.yaml --ask-vault-pass -e "update_service=true"`
