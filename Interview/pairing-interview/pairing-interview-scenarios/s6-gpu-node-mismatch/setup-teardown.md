# **Scenario 6: Setup, Verification, and Teardown**

## **Setup the Faulty Configuration**

### **1️. Deploy a GPU Job on the Wrong Node Type**
Apply a faulty job (`faulty-job.yaml`) that **requests a high-memory GPU workload** but **is assigned to a T4 node**:
```
kubectl apply -f faulty-job.yaml
```
### **2️. Confirm That the Job is Running Inefficiently**
Check GPU memory usage:
```
kubectl exec -it $(kubectl get pod -l job=faulty-job -o jsonpath=”{.items[0].metadata.name}”) – nvidia-smi
```
- **Expected Output:**  
  - **High GPU memory usage (close to limit).**  
  - **Low GPU compute utilization (~20-30%).**

Check pod placement:
```
kubectl get pods -o wide
```
- **Expected Output:**  
  - The pod is **assigned to a T4 node** instead of an **A100 node**.

---

## **Teardown**
After the scenario is completed:
```
kubectl delete -f corrected-job.yaml
kubectl delete pod –all -n default
```
---

This ensures a **structured and repeatable** interview exercise.