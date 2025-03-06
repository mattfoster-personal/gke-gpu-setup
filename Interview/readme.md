# Fault Injection Scenarios for GPU Cluster Interview

## Overview
This document outlines a set of fault injection scenarios designed to test a candidate’s ability to diagnose and resolve issues in a multi-tenant GPU-enabled Kubernetes cluster. Each scenario introduces a deliberate misconfiguration or failure that the candidate must identify and fix.

---

## 1️⃣ Workload Execution Failures

### **Scenario 1: Architecture Mismatch**
- **Issue:** A user submits a job that is built for `arm64`, but all nodes are `amd64`.
- **Expected Failure:** The pod enters `CrashLoopBackOff` with `exec format error`.
- **Candidate Task:**
  1. Identify why the pod is failing (`kubectl logs` and `kubectl describe`).
  2. Determine the correct architecture (`kubectl describe node`).
  3. Modify the job spec to use a compatible image.

### **Scenario 2: Missing GPU Resources**
- **Issue:** A job requests GPUs, but the node it lands on does not have any.
- **Expected Failure:** The pod remains in `Pending` state indefinitely.
- **Candidate Task:**
  1. Identify why the pod is stuck (`kubectl describe pod`).
  2. Verify GPU node availability (`kubectl get nodes -o wide`).
  3. Add appropriate `nodeSelector` or `resource requests`.

### **Scenario 3: Insufficient GPU Memory**
- **Issue:** A job requests 32GB of GPU memory, but the available GPUs only have 16GB.
- **Expected Failure:** The job is scheduled but crashes due to OOM (Out of Memory).
- **Candidate Task:**
  1. Identify the failure (`kubectl logs`).
  2. Check GPU memory constraints (`nvidia-smi`).
  3. Adjust the job’s resource requests.

---

## 2️⃣ Cluster Misconfigurations

### **Scenario 4: Broken RBAC**
- **Issue:** A user from `tenant-a` can list pods in `tenant-b`.
- **Expected Failure:** `kubectl get pods -n tenant-b` succeeds for `tenant-a`, violating isolation.
- **Candidate Task:**
  1. Inspect RBAC rules (`kubectl get rolebindings -n tenant-b`).
  2. Identify why `tenant-a` has access.
  3. Fix the RBAC misconfiguration using Terraform.

### **Scenario 5: Incorrect GPU Quotas**
- **Issue:** A tenant (`tenant-b`) is using more GPUs than allocated.
- **Expected Failure:** GPU quota enforcement is not working.
- **Candidate Task:**
  1. Check the current resource quotas (`kubectl get resourcequotas -n tenant-b`).
  2. Verify that GPU limits are enforced.
  3. Modify the quota in Terraform to apply restrictions.

### **Scenario 6: Node Selector Mismatch**
- **Issue:** A workload specifies a node selector that does not match any available nodes.
- **Expected Failure:** The job stays in `Pending` state indefinitely.
- **Candidate Task:**
  1. Investigate the pending pod (`kubectl describe pod`).
  2. Check available node labels (`kubectl get nodes --show-labels`).
  3. Update the job’s node selector to match a GPU node.

---

## 3️⃣ Performance & Observability Issues

### **Scenario 7: GPU Underutilization**
- **Issue:** A workload requests multiple GPUs, but utilization remains low.
- **Expected Failure:** GPUs appear allocated but show near-zero utilization.
- **Candidate Task:**
  1. Check GPU utilization (`nvidia-smi` or Prometheus `DCGM_FI_DEV_GPU_UTIL`).
  2. Investigate if the workload is running in CPU mode instead of GPU.
  3. Modify the job spec to explicitly use GPU devices.

### **Scenario 8: Unbalanced Workload Distribution**
- **Issue:** One node is fully utilized while another identical GPU node remains idle.
- **Expected Failure:** Jobs do not get scheduled across nodes evenly.
- **Candidate Task:**
  1. Analyze pod distribution (`kubectl get pods -o wide`).
  2. Investigate scheduling constraints (`kubectl describe node`).
  3. Adjust workload parallelism or node affinity to improve bin-packing.

### **Scenario 9: Broken Logging & Monitoring**
- **Issue:** A workload is running but logs and metrics are missing from Prometheus/Grafana.
- **Expected Failure:** No logs appear in `kubectl logs`, and GPU utilization is not recorded.
- **Candidate Task:**
  1. Investigate missing logs (`kubectl logs`, `kubectl get events`).
  2. Verify Prometheus scraping configuration.
  3. Fix missing annotations or exporters.

---

## 4️⃣ Infrastructure as Code (Terraform) Challenges

### **Scenario 10: Firewall Rules Blocking Access**
- **Issue:** A newly added tenant (`tenant-c`) cannot pull images or access external services.
- **Expected Failure:** Pods fail due to networking errors (`ErrImagePull`, `Connection timeout`).
- **Candidate Task:**
  1. Check networking configuration (`kubectl describe pod`).
  2. Identify missing firewall rules.
  3. Modify Terraform to allow outbound access.

### **Scenario 11: Incorrect ClusterRoleBinding**
- **Issue:** A service account does not have permissions to create GPU workloads.
- **Expected Failure:** Job creation fails with `Forbidden` error.
- **Candidate Task:**
  1. Identify why the job cannot start (`kubectl describe job`).
  2. Check service account permissions (`kubectl get clusterrolebindings`).
  3. Fix the IAM role in Terraform.

---

## How to Use These Scenarios
- Faults should be injected **before the interview starts** so candidates walk into an already misconfigured environment.
- Candidates should be expected to **diagnose and resolve** each issue using `kubectl`, Prometheus, and Terraform.
- Interviewers should **take note of the debugging approach**, not just the final fix.

---