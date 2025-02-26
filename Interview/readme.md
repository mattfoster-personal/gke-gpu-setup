# Pairing Exercise: Multi-Tenant GPU Workloads with Terraform

## Duration: 90-120 mins
- GPU Node Validation & Cluster Readiness (15 mins)
- Terraform: Extending Multi-Tenant Infrastructure (30-40 mins)
- Deploying AI Workloads Across Multiple Tenants (20-30 mins)
- Investigating & Fixing Security/Performance Issues (15-20 mins)

---

## Provided Setup
- GKE cluster with GPU-enabled nodes (pre-provisioned)
- Terraform codebase defining the cluster and GPU node pools
- Basic multi-tenant setup with namespaces, quotas, and RBAC
- Pre-built AI workload container
- Monitoring & logging (Observability)

---

## Part 1: GPU Node Validation & Cluster Readiness (15 mins)
### Goal: Ensure the candidate understands GPU provisioning & cluster structure.

### Tasks:
1. Check if GPU nodes are provisioned & labeled correctly (`kubectl get nodes -o wide`).
2. Validate that NVIDIA drivers & GPU Operator are installed (`kubectl get pods -n gpu-operator`).
3. Confirm that GPUs are discoverable (`kubectl describe node`, `nvidia-smi`).
4. Explain how GPU auto-scaling works in GKE.

### What We’re Looking For:
- Can they correctly verify GPU availability?
- Do they understand GPU node auto-provisioning?
- Can they explain why GPU Operator is needed in GKE?

---

## Part 2: Terraform - Extending Multi-Tenant Infrastructure (30-40 mins)
### Goal: Ensure they can modify and apply Terraform configurations to improve multi-tenancy.

### Tasks:
1. Add a new tenant (`tenant-c`) using Terraform (namespace, quotas, RBAC).  
2. Modify GPU quotas for `tenant-a` and `tenant-b` in Terraform (e.g., limit GPUs to 1 per tenant).  
3. Apply Terraform changes and verify (`terraform apply` + `kubectl get namespaces, resourcequotas`).  
4. Fix a misconfiguration: The Terraform file incorrectly allows `tenant-a` to access `tenant-b`'s pods.

### What We’re Looking For:
- Can they write and apply Terraform changes correctly?
- Do they understand how to enforce GPU resource limits with Terraform?
- Can they debug and fix misconfigurations in infrastructure code?

---

## Part 3: Deploying AI Workloads Across Multiple Tenants (20-30 mins)
### Goal: Ensure they can deploy AI workloads in isolated multi-tenant environments.

### Tasks:
1. Deploy AI inference jobs in `tenant-a` and `tenant-b`.  
2. Ensure each workload only consumes the assigned GPU quota.  
3. Verify that workloads are correctly isolated between tenants.  
4. Observe resource utilization and explain GPU scheduling behavior.

### What We’re Looking For:
- Can they correctly deploy GPU workloads per tenant?
- Do they understand namespace-based GPU resource limitations?
- Can they validate that tenants don’t interfere with each other?

---

## Part 4: Investigating & Fixing Security/Performance Issues (15-20 mins)
### Goal: Evaluate problem-solving skills in a multi-tenant GPU cluster.

### Tasks:
1. A user in `tenant-a` can list pods from `tenant-b`. Investigate why and fix it in Terraform.  
2. A job in `tenant-b` is using more GPUs than allowed. Debug and fix the quota configuration.  
3. Observability is broken for one tenant—fix missing logs and ensure per-tenant monitoring.

### What We’re Looking For:
- Can they properly lock down tenant boundaries with RBAC?
- Do they understand GPU scheduling fairness across tenants?
- Can they troubleshoot Terraform-based security misconfigurations?

## Part 5: Debugging through observability - Prometheus (15-20 mins)