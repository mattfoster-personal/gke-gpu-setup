# Scenario 3: Insufficient GPU Memory - Briefing & Solution

## **Background**
A user has submitted a **GPU workload** to the cluster, but the job **fails due to an Out-of-Memory (OOM) error**.

The candidate must **diagnose and resolve** the issue.

---

## **Problem Statement**
- The job **requests 1 GPU** but attempts to allocate **more memory than available**.
- The pod starts but crashes with a **CUDA OOM error**.
- The issue is caused by **a too-large batch size** consuming excessive GPU memory.

---

## **Candidate Task**
The candidate should:
1. **Identify why the pod is failing** (`kubectl logs` to find the OOM error).
2. **Verify available GPU memory** (`nvidia-smi` inside the pod).
3. **Reduce memory usage** by adjusting the batch size.

---

## **Expected Debugging Process**
1️. **Check pod status**
```
kubectl get pods -n default
```

2️. **Retrieve pod logs to confirm the OOM error**
```
kubectl logs faulty-job-xyz -n default
```
**Key indicator:** `RuntimeError: CUDA out of memory`

3️. **Check available GPU memory**
```
kubectl exec -it faulty-job-xyz -- nvidia-smi
```
**Key indicator:** GPU is fully allocated.

---

## **Solution**
To resolve this:
1. **Reduce the batch size** to lower memory usage.

Edit `faulty-job.yaml`:
```yaml
command: ["python3", "/app/train_imdb_bert.py", "--batch_size", "64"]
```

Apply the fix:
```
kubectl apply -f faulty-job.yaml
```

2. **Confirm the job now runs successfully**
```
kubectl get pods -n default
```
The pod should move from `Error` → `Running`.

---

## **Key Takeaways**
- **GPU OOM errors occur when memory usage exceeds available GPU capacity.**
- **Use `kubectl logs` to identify out-of-memory errors.**
- **Reduce batch size to fit within GPU memory limits.**