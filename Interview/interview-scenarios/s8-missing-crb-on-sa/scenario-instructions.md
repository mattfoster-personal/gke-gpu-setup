# Scenario 8: Incorrect ClusterRoleBinding

## **Scenario Overview**
- A **new service account (`gpu-job-sa`)** has been assigned to execute a GPU workload.
- The service account **lacks proper permissions** to create a job.
- This results in **a Forbidden error**, preventing job execution.

---

## **Candidate Task**
The candidate must diagnose and fix the issue by **granting the correct RBAC permissions**.

### **Expected Debugging Steps**
**1️. Identify the Service Account in Use**
```sh
kubectl get pods faulty-job -o jsonpath="{.spec.serviceAccountName}"
```
- Confirms that `gpu-job-sa` is the assigned service account.

**2️. Check the RoleBinding**
```sh
kubectl get clusterrolebinding faulty-gpu-job-binding -o yaml
```
- Shows that the service account has **only read permissions** (`view` role).

**3️. Modify the RoleBinding**
- The **solution** is to grant a proper role, such as `edit` or a **custom role** allowing job creation.

Replace the `view` role in the `ClusterRoleBinding`:
```yaml
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit  # Correct role, allows creating jobs
```
Apply the fix:
```sh
kubectl apply -f fixed-clusterrolebinding.yaml
```

**4️. Restart the Job**
```sh
kubectl delete job faulty-job
kubectl apply -f faulty-job.yaml
```

**5️. Verify the Fix**
Check if the pod starts:
```sh
kubectl get pods
kubectl logs faulty-job
```

---

## **Expected Outcome**
- The job should **now start successfully** and execute on the GPU.
- `torch.cuda.is_available()` should return `True`, confirming GPU access.

---

## **Key Learnings**
- Candidates should **check RBAC permissions** early instead of retrying job creation multiple times.
- **Good candidates** will recognize the missing permission **before manually editing the role**.