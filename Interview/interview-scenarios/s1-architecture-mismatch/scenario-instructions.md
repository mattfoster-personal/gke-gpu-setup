# Fault Injection Scenario 1: Architecture Mismatch

## **Objective**
This scenario tests the candidate's ability to debug workload execution failures caused by architecture mismatches between the container image and the GPU nodes.

## **Problem Statement**
A user has submitted a training job, but the pod repeatedly enters `CrashLoopBackOff`. The logs show an `exec format error`. The cluster consists of `amd64` GPU nodes, but the container image may not be compatible.

## **What the Candidate Sees**
- The pod fails to start (`CrashLoopBackOff`).
- Checking the logs (`kubectl logs <pod-name>`) reveals:
```
standard_init_linux.go:219: exec user process caused: exec format error
```
- The job appears correctly scheduled but never successfully starts.

---

## **Candidate’s Debugging Process**
The candidate should work through the following steps:

### **Step 1: Confirm the Error**
- **Command:**
```
kubectl get pods -n default
```
- Expected Output:
  ```
  NAME                            READY   STATUS             RESTARTS   AGE
  training-job-abc123             0/1     CrashLoopBackOff   5          3m
  ```

- **Command:**
```
kubectl logs 
```
- Expected Output:
  ```
  standard_init_linux.go:219: exec user process caused: exec format error
  ```

---

### **Step 2: Identify Node Architecture**
- **Command:**
kubectl get nodes -o wide
- Expected Output:
  ```
  NAME                               STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION   ARCH
  gke-gpu-node-1                     Ready    <none>   10d    v1.27     10.10.0.1     35.198.49.22  Ubuntu 22.04        5.15.0-1073-gke  amd64
  ```
- The node architecture is `amd64`.

---

### **Step 3: Verify Container Image Architecture**
- **Command:**
```
crane manifest gcr.io/ai-research-e44f/faulty-image:latest | jq ‘.manifests[].platform’
```
- Expected Output:
  ```json
  {
    "architecture": "arm64",
    "os": "linux"
  }
  ```

---

## **Candidate’s Solution**
1. **Find the Correct Image**
 - Check if a `linux/amd64` version of the image exists:
   ```
   crane manifest gcr.io/ai-research-e44f/faulty-image:latest | jq '.manifests[].platform'
   ```
 - If a `linux/amd64` version exists, update the deployment spec to use that.

2. **Update the Kubernetes Job**
 - Modify the job spec (`kubectl edit deployment training-job`):
   ```yaml
   spec:
     containers:
       - name: training-container
         image: gcr.io/ai-research-e44f/correct-image:latest
   ```

3. **Redeploy the Job**

```
kubectl rollout restart deployment training-job
```
---

## **Evaluation Criteria**
**Identifies** that the issue is due to an `exec format error`.  
**Confirms** that the node architecture is `amd64` but the image is built for `arm64`.  
**Uses `crane`** or other tools to inspect the image architecture.  
**Proposes the correct fix**:
- Uses an existing `amd64` image **instead of rebuilding**  
**Implements and verifies** that the fix works.

