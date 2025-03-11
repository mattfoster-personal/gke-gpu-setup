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

## **Step 1: Confirm the Error**
- **Command:**
  ```sh
  kubectl get pods -n default
  ```
- **Expected Output:**
  ```sh
  NAME                            READY   STATUS             RESTARTS   AGE
  faulty-job                      0/1     CrashLoopBackOff   5          3m
  ```
  
- **Command:**
  ```sh
  kubectl logs faulty-job
  ```
- **Expected Output:**
  ```sh
  standard_init_linux.go:219: exec user process caused: exec format error
  ```
  - This error indicates an **architecture mismatch**.

---

## **Step 2: Identify Node Architecture**
- **Command:**
  ```sh
  kubectl get nodes -o wide
  ```
- **Expected Output:**
  ```sh
  NAME                               STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION   ARCH
  gke-gpu-node-1                     Ready    <none>   10d    v1.27     10.10.0.1     35.198.49.22  Ubuntu 22.04        5.15.0-1073-gke  amd64
  ``````
  - **The node architecture is `amd64`**, meaning it cannot run `arm64` images.

---

## **Step 3: Verify Container Image Architecture**
- **Command:**
  ```sh
  crane manifest arm64v8/python | jq '.architecture'
  ```
- **Expected Output:**
  ```json
  "arm64"
  ```

---

## **Candidate’s Solution**
### **Step 4: Find the Correct Image**
   - Since the node is \`amd64\`, we need to use an \`amd64\`-compatible image.
   - **Correct Image:**
     ```sh
     crane manifest python:3.9-slim | jq '.architecture'
     ```
     - Expected Output: \`"amd64"\`

---

### **Step 5: Update the Kubernetes Job**
   - Modify the job spec (\`kubectl edit job faulty-job\`):
     ```yaml
     spec:
       template:
         spec:
           containers:
             - name: test-container
               image: python:3.9-slim  # ✅ Correct architecture
               command: ["python3"]
               args: ["-c", "print('Hello from Python!')"]
     ```

---

### **Step 6: Redeploy the Job**
   ```sh
   kubectl delete job faulty-job
   kubectl apply -f faulty-job.yaml
   ```
   - **Expected Outcome:** The job should now execute successfully.
---

## **Evaluation Criteria**
**Identifies** that the issue is due to an `exec format error`.  
**Confirms** that the node architecture is `amd64` but the image is built for `arm64`.  
**Uses `crane`** or other tools to inspect the image architecture.  
**Proposes the correct fix**:
- Uses an existing `amd64` image **instead of rebuilding**  
**Implements and verifies** that the fix works.

