# Scenario 3: Insufficient GPU Memory - Setup Guide

## **Objective**
This scenario introduces a misconfiguration where a job **requests more GPU memory than is available** on any single GPU device.  
The candidate must diagnose why the job **fails due to an Out-of-Memory (OOM) error** and apply a fix.

---

## **Setup**

### **1️. Deploy the Faulty Job**
Create a job that **requests 24GB of GPU memory**, but the available GPUs **only have 16GB each**.

Apply the job:

```
kubectl apply -f faulty-job.yaml
```

---

## **Verification**

### **2️. Confirm the Job Crashes**
List the running pods:

```
kubectl get pods -n default
```

Expected output:
```
NAME           READY   STATUS    RESTARTS   AGE
faulty-job-xyz   0/1     Error     1          2m
```

Check the pod logs to confirm an **Out-of-Memory (OOM) error**:

```
kubectl logs faulty-job-xyz -n default
```

Expected output:
```
RuntimeError: CUDA out of memory. Tried to allocate 4.00 GiB (GPU memory usage: 15.5 GiB / 16 GiB)
```

### **3️. Verify Available GPU Memory**
Check the memory usage on the node:

```
kubectl exec -it faulty-job-xyz -- nvidia-smi
```

Expected output:
```
+-----------------------------------------------------------------------------+
| GPU  Name        Memory-Usage   Total-Memory |
|-----------------+-------------+-------------|
|  0  Tesla T4     15360MiB /  15360MiB       |
+-----------------------------------------------------------------------------+
```

Since the GPU has **16GB total**, and the job **requires more**, it crashes.

---

## **Teardown**
After the interview, clean up the misconfigured job:

```
kubectl delete job faulty-job -n default
```

---