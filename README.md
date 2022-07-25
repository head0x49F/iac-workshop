##GCP+Terraform+Ansible

We will use Terraform for provisioning and orchestration, and Ansible for configuration and adding software. Requierements:
1. Terraform
2. Ansible
3. Google Cloud SDK

First, be sure to run:
```bash
gcloud auth application-default login
```
so you don’t need set up GCP access manually.

Go to terraform folder and run:
```bash
terraform init
```
```bash
terraform apply
```
After creating all of your resources you can print the value for the static IP:
```bash
terraform output public_ip
```
And now you can use SSH to connect to the VM:
```bash
ssh -i .ssh/google_compute_engine <gcp-username>@<public_ip>
```

Now, go to ansible folder.
1. Set ansible_host in inventory file (your public_ip).
2. Specify remote_user (your gcp-username) in gcp_provision.yml
3.`become` parameter gives you superuser priveleges, so you need to specify `name` parameter at line 27 for adding your "gcp-username" to "docker" group.($USER won`t work, because $USER=root at that moment).
4. Run:
```bash
ansible-playbook gcp_provision.yml
```
