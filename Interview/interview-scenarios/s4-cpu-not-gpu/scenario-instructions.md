# Scenario 4: GPU Underutilization - Briefing & Solution

## **Background**
A user submits a job that **should run on a GPU**, but **GPU utilization remains at 0%**.  
The candidate must **diagnose and resolve** the issue.

---

## **Problem Statement**
- The job **requests a GPU** (`nvidia.com/gpu: 1`) but is configured to **run on CPU only**.
- The workload **allocates a GPU but does not use it**.
- The TensorFlow configuration explicitly **hides GPU devices**.

---

## **Candidate Task**
The candidate should:
1. **Identify why GPU utilization is 0%** (`nvidia-smi` inside the pod).
2. **Confirm that TensorFlow is running on CPU instead of GPU**.
3. **Modify the workload to correctly use GPU devices**.

---

## **Expected Debugging Process**
1️. **Verify that a GPU is allocated**
\```
kubectl describe pod faulty-job-xyz -n default | grep "nvidia.com/gpu"
\```
**Key indicator:** The GPU is assigned, but usage is 0%.

2️. **Check TensorFlow's device list**
\```
kubectl logs faulty-job-xyz | grep "Using devices"
\```
**Key indicator:** `Using devices: []` (No GPUs detected).

3️. **Manually list available GPUs**
\```
kubectl exec -it faulty-job-xyz -- python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
\```
**Key indicator:** `[]` (No GPUs available).

---

## **Solution**
To fix the issue, **remove the line that disables GPU execution**.

Edit `faulty-job.yaml`:
\```yaml
args:
  - |
    import tensorflow as tf
    print("Using devices:", tf.config.list_physical_devices('GPU'))
\```

Apply the fix:
\```
kubectl apply -f faulty-job.yaml
\```

---

## **Key Takeaways**
- **A GPU being allocated does not guarantee that a job is using it.**
- **Use `nvidia-smi` and `tf.config.list_physical_devices('GPU')` to verify GPU utilization.**
- **Incorrect configuration can force workloads to run on CPU even when GPUs are available.**
