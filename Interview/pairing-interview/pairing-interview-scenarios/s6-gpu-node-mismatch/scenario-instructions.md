# **Scenario 6: Inefficient GPU Utilization Due to Node Mismatch**

## **Issue:**
A machine learning engineer submits a workload that is **optimized for high-memory A100 GPUs**, but the job is scheduled onto **lower-memory T4 GPUs**. This results in **severely degraded performance** and **inefficient GPU usage**.

## **Expected Failure:**
- The job **runs**, but **much slower than expected**.
- **GPU memory is exhausted**, leading to **frequent cache flushes and slower execution**.
- **Resource utilization in Prometheus/Grafana appears inefficient**.

## **Candidate Task:**
1. **Diagnose the cause of poor GPU performance**:
   - Check logs using `kubectl logs`
   - Inspect node details with `kubectl describe pod`
   - Monitor GPU metrics via `nvidia-smi` and Prometheus
2. **Verify the workload's GPU requirements**:
   - Check pod spec via `kubectl get pods -o yaml`
   - Identify node assignment (`kubectl get pods -o wide`)
3. **Modify the workload’s node selection policy** to ensure it runs on **A100 nodes instead of T4 nodes**.

## **Proposed Fix**
- **Identify and Remove the Restrictive Node Selector**

```
kubectl get pod faulty-job -o yaml | grep nodeSelector
```
- **Expected Output:** Shows `cloud.google.com/gke-accelerator: "nvidia-tesla-t4"`
- **Fix:** Edit the deployment and **update the node selector** to `nvidia-a100`.

- **Delete and Redeploy the Job**

```
kubectl delete -f faulty-job.yaml
kubectl apply -f corrected-job.yaml
```

---

## **Key Learning Points**
- Understanding **GPU selection and node scheduling** in Kubernetes.
- Recognizing **GPU memory bottlenecks** and performance inefficiencies.
- Debugging **misconfigured node selectors** impacting workload performance.