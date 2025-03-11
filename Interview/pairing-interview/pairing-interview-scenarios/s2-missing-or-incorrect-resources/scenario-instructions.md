# Scenario 2: Insufficient GPU Resources - Briefing & Solution

## **Background**
A user has submitted a **GPU workload** to the cluster, but the job remains **stuck in Pending** indefinitely.

The candidate must **diagnose and resolve** the issue.

---

## **Problem Statement**
- The job **requests 4 GPUs**, but no available node has that many.
- As a result, the Kubernetes scheduler **cannot find a suitable node**.
- The pod remains in `Pending` state with **FailedScheduling** events.

---

## **Candidate Task**
The candidate should:
1. **Identify why the pod is stuck** (`kubectl get pods` and `kubectl describe pod`).
2. **Verify GPU availability across nodes** (`kubectl get nodes -o custom-columns=...`).
3. **Adjust the GPU request to fit available nodes**.

---

## **Expected Debugging Process**
1. **Check pod status**
```
kubectl get pods -n default
```

2️. **Describe the pod to see scheduling issues**
```
kubectl describe pod faulty-job-xyz -n default
```
**Key indicator:** `Insufficient nvidia.com/gpu`

3️. **Check available GPUs per node**
```
kubectl get nodes -o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia.com/gpu
```
**Key indicator:** No node has 4 GPUs.

---

## **Solution**
To resolve this:
1. **Modify the job's resource request** to fit within available GPUs per node.

Edit `faulty-job.yaml`:
```yaml
resources:
  limits:
    nvidia.com/gpu: 2  # Adjusted to fit the available GPUs
```

Apply the fix:
```
kubectl apply -f faulty-job.yaml
```
2. **Confirm the job now schedules successfully**
```
kubectl get pods -n default
```
The pod should move from `Pending` → `Running`.

---


## **Key Takeaways**
- **Kubernetes will not schedule a pod if the requested resources exceed any node's capacity.**
- **Use `kubectl describe pod` to check scheduling failures.**
- **Modify resource requests to align with available node capacity.**

---