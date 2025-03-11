# Scenario 8: Incorrect ClusterRoleBinding (Setup, Verification, and Teardown)

## **Setup Instructions**
This guide provides the steps to **inject a faulty role binding** before the interview.

---

### **1️. Create a Faulty Service Account**
```sh
kubectl create sa gpu-job-sa --namespace default
```
- This **service account** will be used by the faulty job.
- It currently has **no permissions** to create GPU workloads.

---

### **2️. Deploy Faulty ClusterRoleBinding**
The following faulty-job.yaml is `ClusterRoleBinding` **incorrectly grants read-only permissions** to the service account, preventing job creation.

- **Why is this faulty?**
  - The `view` role only **allows reading** resources.
  - It **does not** allow creating jobs or allocating GPUs.

Apply the faulty role:
```sh
kubectl apply -f faulty-clusterrolebinding.yaml
```

---

### **3️. Deploy the Faulty Job**
Apply the job:
```sh
kubectl apply -f faulty-job.yaml
```

---

### **4️. Verify the Failure**
The pod should **fail to start**, and `kubectl describe job faulty-job` should show:
```
Error: Forbidden - service account does not have permission to create jobs
```

---

## **Teardown Instructions**
To **reset the environment** after the interview:
```sh
kubectl delete job faulty-job
kubectl delete clusterrolebinding faulty-gpu-job-binding
kubectl delete sa gpu-job-sa
```