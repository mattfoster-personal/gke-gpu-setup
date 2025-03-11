# Scenario 7: Broken Logging & Monitoring - Briefing & Solution

## **Background**
A user runs a **GPU workload**, but **logs are missing**, and **GPU utilization does not appear in Prometheus**.  
The candidate must **diagnose why logs and metrics are not collected and fix the issue**.

---

## **Problem Statement**
- Logs are **missing from `kubectl logs`**, making debugging difficult.
- GPU utilization is **not reported in Prometheus**.
- The workload is running **but lacks proper monitoring annotations**.

---

## **Candidate Task**
The candidate should:
1. **Identify why logs are missing from `kubectl logs`.**
2. **Investigate why Prometheus is not collecting GPU utilization.**
3. **Modify the job to ensure proper logging and monitoring.**

---

## **Expected Debugging Process**
1️. **Check if the container outputs logs to stdout/stderr**
```
kubectl logs -n default faulty-job-xyz
```
**Key indicator:** No logs appear.

2️. **Confirm logging driver settings**
```
kubectl describe pod faulty-job-xyz | grep log
```
**Key indicator:** Logs are not being collected.

3️. **Verify Prometheus annotations**
```
kubectl describe pod faulty-job-xyz | grep annotations
```
**Key indicator:** **No `prometheus.io/scrape` annotations**.

---

## **Solution**
### **1️. Enable Logging**
Modify `faulty-job.yaml` to ensure logs are written to stdout:

```yaml
          args:
            - |
              import torch
              import time
              print("Starting GPU workload...")  # Ensure log output
              print(f"Running on device: {torch.cuda.get_device_name(0)}")
              for i in range(10):
                  print(f"Step {i+1} completed")
                  time.sleep(5)  # Simulated workload
```

Apply the fix:

```
kubectl apply -f faulty-job.yaml
```

---

### **2️. Enable Prometheus Monitoring**
Modify `faulty-job.yaml` to include Prometheus annotations:

```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9100"
```

Apply the fix:

```
kubectl apply -f faulty-job.yaml
```

---

## **Key Takeaways**
- **Always ensure logs are written to stdout/stderr for `kubectl logs` to capture them.**
- **Prometheus requires explicit pod annotations to scrape GPU metrics.**
- **Use `kubectl describe pod` to check if logs and annotations are properly set.**
