# Fault Injection Scenario 1: Architecture Mismatch - Setup Guide

This script sets up a misconfigured workload where a GPU training job is scheduled on an `amd64` node but uses an `arm64` container image, causing it to fail with an `exec format error`.

---

## **Prerequisites**
Ensure you have:
- A running **Kubernetes cluster with GPU nodes** (`amd64` architecture).
- `kubectl` installed and configured.
- `crane` installed for inspecting image manifests.

---

## **Step 1: Deploy the Faulty Job**
The following YAML file (`faulty-job.yaml`) creates a **GPU-enabled training job** using an incorrect `arm64` image.

Apply the YAML file to the cluster: 

\```
kubectl apply -f faulty-job.yaml
\```

---

## **Step 2: Verify the Fault**
After applying the deployment, check if the pod enters `CrashLoopBackOff`:

\```
kubectl get pods -n default
\```

Expected output:
\```
NAME                            READY   STATUS             RESTARTS   AGE
faulty-job-abc123      0/1     CrashLoopBackOff   5          2m
\```

To confirm the error:

\```
kubectl logs faulty-job-abc123
\```

Expected output:
\```
standard_init_linux.go:219: exec user process caused: exec format error
\```

---

## **Step 3: Inspect the Image Architecture**
To verify that the issue is due to an incompatible architecture, check the container image:

\```
crane manifest gcr.io/ai-research-e44f/faulty-image:latest | jq '.manifests[].platform'
\```

Expected output:
\```json
{
  "architecture": "arm64",
  "os": "linux"
}
\```

This confirms that the **faulty image is built for ARM64**, while the **cluster nodes are AMD64**.

---

## **Step 4: Candidate Begins Debugging**
Once the scenario is set up:
1. Ensure the candidate **sees the failing job** (`kubectl get pods`).
2. Provide minimal guidance and allow them to **debug using logs and node descriptions**.
3. Allow them to propose and apply a fix (switching to a correct `amd64` image).

**Note:** If they get stuck, use the [hints section](#hints-if-the-candidate-gets-stuck) from the main scenario document.

---

## **Tearing Down the Scenario**
To reset the cluster after the interview:

\```
kubectl delete job faulty-job -n default
\```

This ensures a clean state before running another fault injection scenario.

---

## **Next Steps**
This **setup format** will be followed for other scenarios. Let me know if you need adjustments before moving on! 🚀