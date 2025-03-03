# 1️⃣ Initialize Terraform (only needed the first time)
terraform init

# 2️⃣ Apply Network Configuration
terraform apply --target=module.gke_network

# 3️⃣ Apply IAM Bindings (for cluster-wide Kubernetes RBAC)
terraform apply --target=google_project_iam_binding.cluster_admin_binding

# 4️⃣ Create the GKE Cluster
terraform apply --target=module.gke_cluster

# 5️⃣ Apply ClusterRoleBindings (Kubernetes RBAC)
terraform apply --target=kubernetes_cluster_role_binding.cluster_admin
terraform apply --target=kubernetes_cluster_role_binding.gpu_operator_admin

# 6️⃣ Apply GPU Node Pool
terraform apply --target=module.gpu_node_pool

# 7️⃣ Apply GPU Operator Resource Quotas
terraform apply --target=kubernetes_resource_quota.gpu_operator_quota

# 8️⃣ Deploy GPU Operator via Helm (through Terraform)
terraform apply --target=module.gpu_operator
