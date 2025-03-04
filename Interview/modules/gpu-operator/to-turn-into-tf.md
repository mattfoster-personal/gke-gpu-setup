add a secret for the nvcr.io registry and add it to whatever service account is running the installer (e.g. kube-system)

like so:
kubectl create secret docker-registry nvcr-secret  --docker-server=nvcr.io  --docker-username='$oauthtoken'  --docker-password='YOUR-API-KEY'  --namespace kube-system

kubectl patch serviceaccount default -n gpu-operator -p '{\n  "imagePullSecrets": [{"name": "nvcr-secret"}]\n}'\n


Driver installation
```
curl https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -o cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get install -y cuda-drivers
```

Clusterrole Binding

🔹 Additional Notes for Documentation
✅ Fixing Permissions for Future Cluster Installs

Ensure the user has the correct GCP IAM permissions:

bash
Copy
Edit
gcloud projects add-iam-policy-binding ai-research-e44f \
  --member="user:mfoster@thoughtworks.com" \
  --role="roles/container.clusterAdmin"
Verify the user's ability to create cluster-wide RBAC resources:

bash
Copy
Edit
kubectl auth can-i create clusterrolebindings --as=mfoster@thoughtworks.com
If permissions are missing, manually grant cluster-admin in Kubernetes:

bash
Copy
Edit
kubectl create clusterrolebinding mfoster-cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value account)
✅ For GPU Operator Deployment

Ensure the following ClusterRoleBinding exists before deploying:
bash
Copy
Edit
kubectl create clusterrolebinding gpu-operator-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value account)