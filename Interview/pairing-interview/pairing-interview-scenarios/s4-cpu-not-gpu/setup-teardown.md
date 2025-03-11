# Scenario 4: GPU Underutilization - Setup Guide

## **Objective**
This scenario introduces a misconfiguration where a job **requests GPUs but runs entirely on CPU** due to an incorrect TensorFlow configuration.  
The candidate must diagnose why **GPU utilization is 0%** and fix the workload execution.

---

## **Setup**

### **1️. Deploy the Faulty Job**
We will use the **official TensorFlow GPU image** and force it to run on **CPU mode**.

Apply the job:

```
kubectl apply -f faulty-job.yaml
```

---

## **Verification**

### **2️. Check GPU Allocation**
Verify that the job **appears to use a GPU** but does not actually utilize it.

```
kubectl get pods -n default
```
The pod should be **Running**, not `Error` or `CrashLoopBackOff`.

Verify GPU allocation:

```
kubectl describe pod faulty-job-xyz -n default | grep "nvidia.com/gpu"
```
Output should confirm that **1 GPU is allocated**.

### **3️. Check GPU Utilization**
Log into the container and **check GPU usage**:

```
kubectl exec -it faulty-job-xyz -- nvidia-smi
```
**Expected output:**  
GPU is **allocated** but **utilization remains at 0%**.

Verify TensorFlow's device list:

```
kubectl logs faulty-job-xyz | grep "Using devices"
```
**Expected output:**  
```
Using devices: []
```
This confirms that **no GPU is detected** even though one is assigned.

---

## **Teardown**
After the interview, remove the faulty job:

```
kubectl delete job faulty-job -n default
```

---