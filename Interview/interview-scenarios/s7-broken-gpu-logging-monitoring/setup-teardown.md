# Scenario 7: Broken Logging & Monitoring - Setup Guide

## **Objective**
In this scenario, **GPU workload logs and Prometheus metrics are missing** from monitoring tools.  
The candidate must **diagnose and resolve the missing logs and metrics issue**.

---

## **Setup**

### **1️. Deploy the Faulty Job**
We deploy a GPU workload **without proper logging configuration** and **without Prometheus annotations**.

Apply the job:

```
kubectl apply -f faulty-job.yaml
```

---

## **Verification**

### **2️. Confirm the Job is Running**
Ensure the workload is scheduled on a GPU node:

```
kubectl get pods -n default
```

**Expected output:** The pod should be in `Running` state.

### **3. Check for Missing Logs**
Attempt to retrieve logs:

```
kubectl logs -n default faulty-job-xyz
```

**Expected output:** **No logs appear**, despite the job running.

### **4️. Verify GPU Monitoring**
Check GPU utilization:

```
kubectl exec -it faulty-job-xyz -- nvidia-smi
```

**Expected output:** **GPU is in use, but Prometheus does not report utilization**.

Check Prometheus for GPU metrics:

```
kubectl get pods -n monitoring | grep prometheus
kubectl port-forward -n monitoring <prometheus-pod> 9090
```

**Expected output:** **Metrics are missing from Prometheus**.

---

## **Teardown**
After the interview, remove the faulty job:

```
kubectl delete job faulty-job -n default
```

---