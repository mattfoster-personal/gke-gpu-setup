# GKE GPU Setup

This repository documents the process of setting up a **Google Kubernetes Engine (GKE) cluster with GPU support**, installing the **NVIDIA GPU Operator**, and running **GPU-accelerated workloads**.

## **1. Prerequisites**
Before starting, ensure you have:

- A **Google Cloud** project with billing enabled.
- The **gcloud CLI** installed and initialized.
- Requested **GPU quota** for the required region (default limits are often **0**).
  - Check your quota:
    ```bash
    gcloud compute regions describe southamerica-east1 | grep -i quota
    ```
  - If GPU quota is `0`, request an increase in the **GCP Console → IAM & Admin → Quotas**.

## **2. Create a GKE Cluster with GPU Support**
We create a **regional** cluster with **GPU-ready** configurations.

```bash
gcloud container clusters create demo-cluster1 \
    --region=southamerica-east1 \
    --machine-type=n1-standard-4 \
    --accelerator type=nvidia-tesla-t4,count=1 \
    --num-nodes=1 \
    --release-channel=regular \
    --image-type=UBUNTU_CONTAINERD \
    --disk-type=pd-standard \
    --disk-size=100 \
    --enable-ip-alias \
    --metadata disable-legacy-endpoints=true \
    --enable-autorepair \
    --enable-autoupgrade
```
## **2. Create a GKE Cluster with GPU Nodes**
```bash
gcloud container clusters create gke-gpu-cluster \
    --region=us-central1 \
    --machine-type=e2-standard-4 \
    --num-nodes=1 \
    --release-channel=regular \
    --disk-type=pd-balanced \
    --disk-size=100 \
    --image-type=COS_CONTAINERD \
    --enable-ip-alias \
    --enable-autoupgrade \
    --enable-autorepair \
    --enable-autoscaling --min-nodes=1 --max-nodes=3
```

## **3. Install NVIDIA GPU Operator

The NVIDIA GPU Operator handles driver installation, monitoring, and device plugins.

Add NVIDIA Helm Repo

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
  && helm repo update
```

Install the Operator

```bash
helm install gpu-operator nvidia/gpu-operator \
    --create-namespace --namespace gpu-operator
```

Verify GPU Operator Pods

```bash
kubectl get pods -n gpu-operator
```

Expected Output:
```bash
NAME                                           READY   STATUS
gpu-operator-xxxxxx                            1/1     Running
nvidia-driver-daemonset-xxxxx                  1/1     Running
nvidia-device-plugin-daemonset-xxxxx           1/1     Running
...
```
## 4. Verify GPU Availability in Kubernetes

Once the GPU Operator is running, verify that the node is GPU-enabled.
```
kubectl describe node | grep -i gpu
```
Result:
```
nvidia.com/gpu.count=1
nvidia.com/gpu.product=Tesla-T4
nvidia.com/gpu.present=true
```
Check NVIDIA-SMI inside the Cluster
```
kubectl run gpu-test --rm -it --restart=Never --image=nvidia/cuda:12.2.2-base-ubuntu22.04 -- nvidia-smi
```
Expected Output:
```
+---------------------------+
| GPU  Name        Memory   |
| Tesla T4        15360MiB  |
+---------------------------+
```
## 5. Running a GPU-Accelerated Job

Deploy a TensorFlow GPU Job:

```
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: tensorflow-gpu-test
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: tensorflow-gpu
        image: tensorflow/tensorflow:latest-gpu
        command: ["python", "-c"]
        args:
          - |
            import tensorflow as tf
            print("Num GPUs Available:", len(tf.config.experimental.list_physical_devices('GPU')))
        resources:
          limits:
            nvidia.com/gpu: 1
EOF
```
Check job logs:
```
kubectl logs job/tensorflow-gpu-test
```
Results should looks something like:
```
Num GPUs Available: 1
```
## 7. Next Steps
Now that your GPU cluster is operational, you can:

Run more GPU-accelerated jobs (PyTorch, TensorFlow, CUDA workloads).
Scale the cluster by adding more GPU nodes.
Convert this manual GPU setup into an automated infrastructure deployment.


