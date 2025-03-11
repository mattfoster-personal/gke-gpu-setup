# Scenario 2: Insufficient GPU Resources - Setup Guide

## **Objective**
This scenario introduces a misconfiguration where a job **requests more GPUs than are available on any single node**.  
The candidate must diagnose why the pod is **stuck in Pending** and apply a fix.

---

## **Setup**

### **1️. Deploy the Faulty Job**
Create a job that **requests 4 GPUs**, while available nodes **only have 2 GPUs each**.

Apply the job:

\```
kubectl apply -f faulty-job.yaml
\```

---

## **Verification**

### **2️. Confirm the Job is Stuck**
List the running pods:

\```
kubectl get pods -n default
\```

Expected output:
\```
NAME           READY   STATUS    RESTARTS   AGE
faulty-job-xyz   0/1     Pending   0          2m
\```

Describe the pod to inspect scheduling issues:

\```
kubectl describe pod faulty-job-xyz -n default
\```

Expected error message:
\```
Warning  FailedScheduling  10s  default-scheduler  0/3 nodes are available: 1 Insufficient nvidia.com/gpu.
\```

### **3️. Verify Node GPU Availability**
Check how many GPUs each node has:

\```
kubectl get nodes -o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
\```

Expected output:
\```
NAME                                   GPU
gke-gpu-node-pool-1-abcd123            2
gke-gpu-node-pool-2-efgh456            2
gke-cpu-node-pool-3-ijkl789            <none>
\```

Since no node has **4 GPUs**, the job **cannot be scheduled**.

---

## **Teardown**
After the interview, clean up the misconfigured job:

\```
kubectl delete job faulty-job -n default
\```

---