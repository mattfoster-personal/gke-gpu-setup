# **GPU Cluster Engineer Interview Question Bank**

# **Table of Contents**

- [GPU Resource Allocation & Scheduling](#gpu-resource-allocation--scheduling)
- [Performance Optimization & Bottleneck Resolution](#performance-optimization--bottleneck-resolution)
- [Monitoring, Observability, and Debugging](#monitoring-observability-and-debugging)
- [Multi-Tenancy, Isolation & Security](#multi-tenancy-isolation--security)
- [CI/CD & Infrastructure for ML](#cicd--infrastructure-for-ml)
- [Storage & Networking for ML Workloads](#storage--networking-for-ml-workloads)
- **Architecture Question Bank**
  - [Designing a Scalable Multi-Tenant GPU Cluster](#designing-a-scalable-multi-tenant-gpu-cluster)
  - [Handling a Sudden GPU Resource Surge](#handling-a-sudden-gpu-resource-surge)
  - [Fault Tolerance in a GPU Cluster](#fault-tolerance-in-a-gpu-cluster)
  - [Optimizing GPU-Accelerated Inference at Scale](#optimizing-gpu-accelerated-inference-at-scale)
  - [Hybrid Cloud & On-Prem GPU Workloads](#hybrid-cloud--on-prem-gpu-workloads)
  - [Future-Proofing a GPU Cluster](#future-proofing-a-gpu-cluster)

---

## **GPU Resource Allocation & Scheduling**

### **How does Kubernetes schedule workloads on GPU nodes?**
- **Expected Answer:**  
  - Kubernetes uses **Device Plugins** (like NVIDIA’s) to expose GPUs as schedulable resources.
  - The scheduler ensures pods requesting `nvidia.com/gpu` are assigned to GPU nodes.
  - **NVIDIA Kubernetes Device Plugin** registers available GPUs with kubelet.
  - **NodeSelector, Affinity Rules, and Taints/Tolerations** influence scheduling.

- **Follow-ups:**  
  - How does Kubernetes prevent over-allocation of GPUs?
  - What happens if multiple pods request the same GPU?
  - How would you enforce fair GPU sharing across multiple workloads?

- **Hints if struggling:**  
  - "How does Kubernetes know which nodes have GPUs?"
  - "What role do `nodeSelector` and `affinity` play in scheduling?"

---

## **Performance Optimization & Bottleneck Resolution**

### **A GPU job is running, but utilization is low (<30%). What do you do?**
- **Expected Answer:**  
  - **Check GPU processes** (`nvidia-smi` → see if job is assigned).
  - **Check CPU bottleneck** (`htop` → high CPU usage means dataloading is slow).
  - **Check batch size** (Increase batch size if memory allows).
  - **Use `torch.cuda.profiler` or TensorFlow profiler** to find inefficient layers.

- **Follow-ups:**  
  - How do you tell if the issue is CPU-bound rather than GPU-bound?
  - What tools can help diagnose slow CUDA operations?

- **Hints if struggling:**  
  - "What could cause a GPU job to underutilize the GPU?"
  - "What’s the first thing you’d check in `nvidia-smi`?"

---

## **Monitoring, Observability, and Debugging**

### **What tools do you use to monitor GPU utilization?**
- **Expected Answer:**  
  - **NVIDIA DCGM (Data Center GPU Manager)**.
  - Prometheus/Grafana integration (`DCGM_FI_DEV_GPU_UTIL` metric).
  - `nvidia-smi` for real-time monitoring.

- **Follow-ups:**  
  - How would you track GPU memory leaks?
  - What’s the advantage of integrating DCGM with Prometheus?

- **Hints if struggling:**  
  - "How would you set up real-time monitoring for GPU utilization?"

---

## **Multi-Tenancy, Isolation & Security**

### **How do you enforce fair GPU sharing across teams?**
- **Expected Answer:**  
  - Use **resource quotas** (`kubectl describe resourcequotas`).
  - Apply **Pod Priority & Preemption** for high-priority workloads.
  - Implement **fair-share scheduling** (e.g., `nvidia.com/gpu.memory` constraints).

- **Follow-ups:**  
  - How do you prevent one team from consuming all GPUs?
  - What Kubernetes mechanisms ensure fair scheduling?

- **Hints if struggling:**  
  - "How do you limit GPU resources per namespace?"

---

## **CI/CD & Infrastructure for ML**

### **How do you design a CI/CD pipeline for ML model training?**
- **Expected Answer:**  
  - Automate **data preprocessing, model training, validation, and deployment**.
  - Use **Kubeflow Pipelines** or MLflow for tracking.
  - Implement **model versioning** and rollback strategies.

- **Follow-ups:**  
  - How does CI/CD for ML differ from traditional software CI/CD?
  - What’s the best way to test a trained model before deployment?

- **Hints if struggling:**  
  - "How do you automate retraining of ML models?"

---

## **Storage & Networking for ML Workloads**

### **A deep learning job loads data too slowly. What’s the issue?**
- **Expected Answer:**  
  - **I/O bottlenecks:** Increase `num_workers` in PyTorch `DataLoader`.
  - **Use TFRecord format or Parquet instead of CSVs**.
  - Optimize network-attached storage (NFS → Lustre for high throughput).

- **Follow-ups:**  
  - What’s the impact of slow storage on training speed?
  - How would you diagnose network-related slowdowns?

- **Hints if struggling:**  
  - "What’s the difference between NFS and parallel file systems for ML?"

---

# **Architecture Question Bank**

## **Designing a Scalable Multi-Tenant GPU Cluster**
### **Question:**  
Your company runs a **multi-tenant** GPU cluster shared across multiple teams.  
How would you design the cluster to ensure **efficient GPU utilization, fair resource allocation, and workload isolation**?

### **Discussion Points & Follow-Ups:**
- How do you **partition GPUs** across teams? (MIG, resource quotas, namespaces)
- What scheduling policies would you enforce? (Fair-share, priority-based scheduling)
- How do you handle **idle GPU resources**? (Preemption, job queuing)
- What role does **RBAC** play in multi-tenant security?
- How would you track **per-tenant usage** for billing or monitoring?
- What tools or policies would you use to **prevent GPU resource hoarding**?

---

## **Handling a Sudden GPU Resource Surge**
### **Question:**  
A new project suddenly requires **50% more GPUs than usual**, but your cluster has limited GPU nodes.  
How do you **handle the surge** without impacting ongoing jobs?

### **Discussion Points & Follow-Ups:**
- How would you **scale up GPU capacity dynamically**? (Autoscaling, burst capacity)
- What if you **can’t add more GPUs immediately**? (Preemption, prioritization)
- Would you consider **spot/preemptible GPUs** to handle temporary demand?
- How would you optimize existing workloads **to free up GPUs**?
- How do you ensure a balance between **cost-effectiveness** and **performance needs**?
- What impact does increased GPU demand have on **networking and storage bottlenecks**?

---

## **Fault Tolerance in a GPU Cluster**
### **Question:**  
A **GPU node suddenly fails**, interrupting long-running model training jobs.  
How would you design the system to **recover gracefully**?

### **Discussion Points & Follow-Ups:**
- How do you ensure **checkpointing & resumption** of workloads?
- Would you use **distributed training** to prevent single-node failures?
- How do you prevent **data loss** for jobs running on ephemeral nodes?
- How do you diagnose GPU node failures quickly? (`node-exporter`, DCGM, Prometheus)
- What strategies can **reduce downtime** for critical workloads?
- How would you configure **Kubernetes scheduling** to automatically reschedule failed jobs?

---

## **Optimizing GPU-Accelerated Inference at Scale**
### **Question:**  
You need to **deploy a deep learning model** serving real-time predictions to millions of users.  
How would you **optimize inference performance and cost**?

### **Discussion Points & Follow-Ups:**
- What’s the best approach for **serving models at scale**? (TFServing, Triton, ONNX)
- How do you handle **batching requests** to maximize GPU efficiency?
- What’s the benefit of **FP16 vs FP32 precision** for inference workloads?
- When would you use **CPU-based inference** instead of GPUs?
- How do you decide between **on-prem GPUs vs cloud-based inference**?
- How would you monitor **latency vs throughput trade-offs**?
- What techniques improve **cold-start latency** for model inference?

---

## **Hybrid Cloud & On-Prem GPU Workloads**
### **Question:**  
Your company wants to **run GPU workloads across both on-prem and cloud** for cost efficiency.  
How do you design an architecture that **seamlessly integrates both**?

### **Discussion Points & Follow-Ups:**
- How would you handle **data movement between on-prem and cloud GPUs**?
- Would you use **Kubernetes Federation, Kubeflow, or custom job schedulers**?
- How do you ensure **consistent GPU drivers & software environments**?
- How do you minimize **latency** for cross-cloud GPU workloads?
- What role do **containerization and orchestration** play in hybrid environments?
- How do you balance **cloud burst capacity** with **on-prem reserved GPUs**?
- What security considerations exist when **transferring workloads between cloud and on-prem?**

---

## **Future-Proofing a GPU Cluster**
### **Question:**  
Your company expects **AI workloads to grow 10x** in the next three years.  
How would you **design the GPU infrastructure** today to be scalable & future-proof?

### **Discussion Points & Follow-Ups:**
- What factors determine when to **scale out vs scale up** GPUs?
- How do you **future-proof network bandwidth** for high-throughput AI?
- How does **storage design impact large-scale training**? (e.g., NFS, Lustre, Ceph)
- What role do **containerized ML workflows** play in long-term scalability?
- How would you manage **multi-region GPU deployments**?
- What considerations go into selecting **the next generation of GPUs**?
- How do you ensure that **GPU scheduling policies** remain efficient as workloads grow?