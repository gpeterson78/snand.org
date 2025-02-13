## Remote Execution (Default)

By default, the playbooks are designed to execute on a **remote server** specified in `hosts.yaml`.

### **Step 1: Configure** `**hosts.yaml**` **for Remote Execution**

Ensure `hosts.yaml` is set to target your server:

```
all:
  children:
    docker_host:
      hosts:
        snand:                        # replace with your servername
          ansible_host: 10.0.0.19     # Replace with your server's IP
          ansible_user: your_ssh_user # replace with your ssh username
```

### **Step 2: Run the Playbook**

Run the playbook against the remote server:

```
ansible-playbook -i hosts.yaml playbooks/git-update.yaml --ask-vault-pass
```

---

## Local Execution (On the Server Itself)

For **local execution**, modify `hosts.yaml` to target `localhost`.

### **Step 1: Configure** `**hosts.yaml**` **for Local Execution**

Edit `hosts.yaml` to use `localhost` instead of the remote host:

```
all:
  children:
    docker_host:
      hosts:
        localhost:
          ansible_connection: local
```

### **Step 2: Run the Playbook Locally**

Now, execute the playbook directly on the server:

```
ansible-playbook -i hosts.yaml playbooks/git-update.yaml --ask-vault-pass
```

---

## Switching Between Local and Remote Execution

To switch between **remote** and **local** execution:

- Change `hosts.yaml` to **target the remote server** (`snand`).
    
- Change `hosts.yaml` to **use localhost** for local execution.
    

This ensures that **all playbooks function the same way**, whether executed remotely or directly on the server.

🚀 **You're now set up to manage snand with Ansible in both local and remote environments!**