### **Running cloudflared-manage.yaml Playbook**

#### **Start Cloudflared**

`ansible-playbook -i hosts.yaml playbooks/cloudflared-manage.yaml --ask-vault-pass`

**Stop Cloudflared**

`ansible-playbook -i hosts.yaml playbooks/cloudflared-manage.yaml --ask-vault-pass -e "stop_service=true"`

**Update Cloudflared (Pull Latest Images & Restart)**

`ansible-playbook -i hosts.yaml playbooks/cloudflared-manage.yaml --ask-vault-pass -e "update_service=true"`
