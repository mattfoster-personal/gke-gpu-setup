# Scenario 5: Unbalanced Workload Distribution - Setup Guide

## **Objective**
This scenario introduces a **scheduling imbalance** where **all GPU workloads run on a single node**, while other available GPU nodes remain **idle**.

The candidate must diagnose and adjust the workload scheduling to **ensure even distribution** across multiple GPU nodes.

---

## **Setup**

### **1️. Deploy the Faulty Jobs**
We deploy **three identical GPU workloads**, but all are forced onto the same node due to a scheduling misconfiguration.

Edit the job and append a single gpu-accelerated node name in the placeholder specified.

Apply the job:

```
kubectl apply -f faulty-job.yaml
```

---

## **Verification**

### **2️. Check Job Status**
Confirm that all workloads are running on the same node.

```
kubectl get pods -o wide -n default
```
**Expected output:**  
All jobs are scheduled on the same node (e.g., `gke-gpu-node-1`).

Check node utilization:

```
kubectl top nodes | grep gke
```
**Expected output:**  
One GPU node is overloaded, while others are **idle**.

---

## **Teardown**
After the interview, remove the faulty jobs:

```
kubectl delete job faulty-job -n default
```

---