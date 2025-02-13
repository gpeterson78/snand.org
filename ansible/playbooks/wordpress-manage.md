### **Running wordpress-manage.yaml Playbook**

#### **Start WordPress**

`ansible-playbook -i hosts.yaml playbooks/wordpress-manage.yaml --ask-vault-pass`

**Stop WordPress**

`ansible-playbook -i hosts.yaml playbooks/wordpress-manage.yaml --ask-vault-pass -e "stop_service=true"`

**Update WordPress (Pull Latest Images & Restart)**

`ansible-playbook -i hosts.yaml playbooks/wordpress-manage.yaml --ask-vault-pass -e "update_service=true"`
