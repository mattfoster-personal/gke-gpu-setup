# Scenario 5: Unbalanced Workload Distribution - Briefing & Solution

## **Background**
A user submits multiple GPU workloads, expecting them to be **evenly distributed across available GPU nodes**, but all jobs **get scheduled onto a single node**.  

The candidate must **diagnose and correct the scheduling issue**.

---

## **Problem Statement**
- The cluster has **multiple GPU nodes**, but only one is being used.
- Other GPU nodes remain **idle**, leading to **inefficient resource utilization**.
- The workload scheduling forces **all jobs onto a single node** due to a **nodeSelector misconfiguration**.

---

## **Candidate Task**
The candidate should:
1. **Identify why all workloads are running on one node**.
2. **Verify cluster node resources and GPU availability**.
3. **Modify the workload to allow proper GPU workload distribution**.

---

## **Expected Debugging Process**
1️. **Check the node assignment**
\```
kubectl get pods -o wide -n default
\```
**Key indicator:** All jobs run on the same node.

2️. **Verify GPU utilization per node**
\```
kubectl top nodes | grep gke
\```
**Key indicator:** One node is fully utilized, while others are idle.

3️. **Check the scheduling constraints**
\```
kubectl describe pod faulty-job-xyz -n default | grep "Node:"
\```
**Key indicator:** Node assignment is restricted to a single node.

---

## **Solution**
The fix is to **remove the restrictive nodeSelector** leaving just the t4 node selector so the Kubernetes scheduler can distribute workloads evenly.

Edit `faulty-job.yaml`:
\```yaml
      # Remove this line to allow the default scheduler to distribute jobs evenly
      # nodeSelector:
      #   kubernetes.io/hostname: faulty-gpu-node  
\```

Apply the fix:
\```
kubectl apply -f faulty-job.yaml
\```

---

## **Key Takeaways**
- **Forcing jobs onto a specific node may lead to unbalanced GPU utilization.**
- **Kubernetes' default scheduler is responsible for distributing workloads unless overridden.**
- **To distribute GPU workloads evenly, avoid hardcoding node selectors unless necessary.**

