# **Setting Up a GPU-Powered Kubernetes Cluster on Google Kubernetes Engine (GKE)**

This guide walks you through creating a **GPU-enabled** GKE cluster, setting up **NVIDIA GPU drivers**, and running GPU workloads.

---

## **1. Prerequisites**

Ensure you have:
- A **Google Cloud Project** ([Create one](https://console.cloud.google.com/))
- The **Google Cloud CLI (`gcloud`)** installed ([Install it](https://cloud.google.com/sdk/docs/install))
- Enabled the required APIs:
  ```bash
  gcloud services enable container.googleapis.com compute.googleapis.com
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

## **3. Create a GPU Node Pool**
```bash
gcloud container node-pools create gpu-node-pool \
    --cluster=gke-gpu-cluster \
    --region=us-central1 \
    --machine-type=n1-standard-4 \
    --accelerator type=nvidia-tesla-t4,count=1 \
    --num-nodes=1 \
    --disk-size=100 \
    --disk-type=pd-balanced \
    --image-type=COS_CONTAINERD \
    --enable-autoscaling --min-nodes=0 --max-nodes=3 \
    --node-labels=gpu-node=true \
    --node-taints=nvidia.com/gpu=present:NoSchedule \
    --metadata=disable-legacy-endpoints=true \
    --scopes=https://www.googleapis.com/auth/cloud-platform
```

## **4.  Install NVIDIA CUDA Drivers**
```bash
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/main/daemonset.yaml
```
Ensure the Daemon is working
```bash
kubectl get daemonsets -n kube-system | grep nvidia
```
## **5. Deploy a GPU Job**

Create a file with the below:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: gpu-job
spec:
  template:
    spec:
      restartPolicy: Never
      nodeSelector:
        cloud.google.com/gke-accelerator: "nvidia-tesla-t4"
      tolerations:
        - key: "nvidia.com/gpu"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
      - name: gpu-container
        image: nvidia/cuda:11.0-base
        command: ["nvidia-smi"]
        resources:
          limits:
            nvidia.com/gpu: 1
```
Apply it to your cluster:
```bash
kubectl apply -f filename.yaml
```
Check job usage:
```bash
kubectl get pods
kubectl logs -l job-name=gpu-job
```

## **6. Verify GPU Usage**
```bash
kubectl describe node | grep -A10 Capacity
kubectl get pods -n kube-system
```