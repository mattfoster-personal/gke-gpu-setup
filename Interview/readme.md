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

### **Scenario 2: Missing or Incorrect GPU Resources**
- **Issue:** A job requests GPUs, but either:
  - It is scheduled on a non-GPU node.
  - The requested GPU count exceeds available GPUs per node.
- **Expected Failure:** The pod remains in `Pending` state indefinitely.
- **Candidate Task:**
  1. Identify why the pod is stuck (`kubectl describe pod`).
  2. Verify GPU node availability (`kubectl get nodes -o wide`).
  3. Adjust nodeSelector, affinity, or resource requests to ensure correct scheduling.

### **Scenario 3: Insufficient GPU Memory**
- **Issue:** A job requests 32GB of GPU memory, but the available GPUs only have 16GB.
- **Expected Failure:** The job is scheduled but crashes due to OOM (Out of Memory).
- **Candidate Task:**
  1. Identify the failure (`kubectl logs`).
  2. Check GPU memory constraints (`nvidia-smi`).
  3. Adjust the job’s resource requests.

---

## 2️⃣ Performance & Observability Issues

### **Scenario 4: GPU Underutilization (Forcing CPU Mode)**
- **Issue:** A workload is expected to run on GPUs, but it defaults to CPU mode.
- **Expected Failure:** GPUs appear allocated, but utilization remains low.
- **How We Simulate This:** Modify the workload to **explicitly disable GPU execution**:
  ```python
  import tensorflow as tf
  tf.config.set_visible_devices([], 'GPU')  # Force CPU execution
    ```
- **Candidate Task:**
1. Check GPU utilization (`nvidia-smi` or Prometheus `DCGM_FI_DEV_GPU_UTIL`).
2. Identify if the workload is running in CPU mode instead of GPU.
3. Modify the job spec to explicitly use GPU devices.

### **Scenario 5: Unbalanced Workload Distribution**
- **Issue:** One node is fully utilized while another identical GPU node remains idle.
- **Expected Failure:** Jobs do not get scheduled across nodes evenly.
- **Candidate Task:**
  1. Analyze pod distribution (`kubectl get pods -o wide`).
  2. Investigate scheduling constraints (`kubectl describe node`).
  3. Adjust workload parallelism, node affinity, or MPI configuration.

  **Note:** We previously tried adjusting `parallelism` but were unsuccessful, which is why we explored **MPI for multi-node GPU workloads**. Candidates should discuss how `MPI` helps in workload distribution.

### **Scenario 6: Broken Logging & Monitoring**
- **Issue:** A workload is running, but logs and metrics are missing from Prometheus/Grafana.
- **Expected Failure:** No logs appear in `kubectl logs`, and GPU utilization is not recorded.
- **Candidate Task:**
  1. Investigate missing logs (`kubectl logs`, `kubectl get events`).
  2. Verify Prometheus scraping configuration.
  3. Fix missing annotations or exporters.

---

## 3️⃣ Infrastructure as Code (Terraform) Challenges

### **Scenario 7: Firewall Rules Blocking Access**
- **Issue:** A newly added tenant (`tenant-c`) cannot pull images or access external services.
- **Expected Failure:** Pods fail due to networking errors (`ErrImagePull`, `Connection timeout`).
- **Candidate Task:**
  1. Check networking configuration (`kubectl describe pod`).
  2. Identify missing firewall rules.
  3. Modify Terraform to allow outbound access.

### **Scenario 8: Incorrect ClusterRoleBinding**
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