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

# **Large-Scale Cluster Management & Scaling**

## **1. How do you ensure that a Kubernetes GPU cluster can scale dynamically while maintaining workload reliability?**
- **Expected Answer:**
  - **Autoscaling strategies**:
    - **Cluster Autoscaler** (adjusts node pools based on pod requests)
    - **Horizontal Pod Autoscaler (HPA)** (scales workloads based on CPU/GPU utilization)
    - **Vertical Pod Autoscaler (VPA)** (optimizes individual pod resources)
  - **Preemptible/Spot GPUs**: Handling workloads that can tolerate interruptions.
  - **Priority Classes & Preemption**: Ensuring critical workloads get resources first.
  - **Scaling GPU nodes vs CPU nodes differently**: Some workloads might be CPU-intensive even in GPU-heavy clusters.

- **Follow-ups:**
  - How would you prevent the **Cluster Autoscaler from removing GPU nodes during maintenance events**?
  - What trade-offs exist between **Cluster Autoscaler and HPA/VPA**?
  - How do you design an **autoscaling strategy for burst workloads**?

- **Hints if struggling:**  
  - "How does Kubernetes know when to scale GPU nodes up or down?"
  - "How do you prevent important jobs from being evicted?"

---

## **2. How do you balance cost and performance when running large-scale GPU workloads?**
- **Expected Answer:**
  - **Mix of on-demand and preemptible GPUs**:
    - Use **on-demand GPUs** for critical workloads.
    - Use **preemptible/spot GPUs** for batch processing.
  - **Efficient resource utilization**:
    - **Bin packing strategies** to avoid GPU fragmentation.
    - Using **Multi-Instance GPU (MIG)** for partitioning large GPUs.
  - **Profiling and cost monitoring**:
    - Use **`nvidia-smi`**, **DCGM**, and **Prometheus/Grafana** for monitoring utilization.
    - Identify underutilized GPUs and optimize scheduling.

- **Follow-ups:**
  - What strategies can reduce idle GPU costs?
  - How would you prioritize high-value workloads over low-priority workloads?
  - What trade-offs exist between **buying more GPUs** vs **optimizing scheduling**?

- **Hints if struggling:**  
  - "How can you make better use of preemptible instances?"
  - "What tools help analyze GPU utilization?"

---

## **3. How do you configure and optimize Multi-Instance GPU (MIG) in Kubernetes?**
- **Expected Answer:**
  - **Enabling MIG Mode**:
    - Configure MIG at the driver level (`nvidia-smi -mig 1`).
    - Assign MIG profiles (`nvidia-smi mig -cgi`).
  - **Kubernetes Integration**:
    - Use **NVIDIA GPU Operator** to expose MIG instances.
    - Modify **`device-plugin`** configuration for MIG profiles.
  - **Optimizing MIG usage**:
    - Assign small workloads to **MIG slices**.
    - Ensure **GPU memory allocation** matches workload needs.

- **Follow-ups:**
  - How do you expose MIG slices as Kubernetes resources?
  - What workloads benefit most from MIG?
  - How does MIG impact GPU scheduling and isolation?

- **Hints if struggling:**  
  - "How do you allocate a single A100 to multiple users?"
  - "What trade-offs exist between using MIG vs full GPU access?"

---

## **4. How do you allocate contiguous GPUs for optimizing distributed training?**
- **Expected Answer:**
  - **Affinity-based scheduling**:
    - Use **Pod Affinity/Anti-Affinity** to schedule jobs on adjacent GPUs.
    - Configure **`topologyManager`** to prefer socket-aligned allocations.
  - **Networking considerations**:
    - Optimize **NVIDIA NVLink topology** for better inter-GPU communication.
    - Use **RDMA/Infiniband** for high-speed interconnects.
  - **Framework-specific optimizations**:
    - Use **PyTorch Distributed Data Parallel (DDP)** or **TensorFlow MirroredStrategy**.
    - Profile inter-GPU communication with **`nsys`** and **`nvidia-smi topo`**.

- **Follow-ups:**
  - How do you ensure GPUs allocated to a job are on the same NUMA node?
  - How does NVLink improve performance over PCIe?
  - When would you need to use a dedicated GPU interconnect?

- **Hints if struggling:**  
  - "How do you ensure all GPUs assigned to a pod are on the same physical node?"
  - "What’s the role of NUMA awareness in GPU scheduling?"

---

## **5. What cluster changes can be done without causing Kubernetes to tear down the entire cluster?**
- **Expected Answer:**
  - **Scaling up/down nodes**: Adjusting **node pools** without impacting workloads.
  - **Adding/removing node pools**: Dynamically modifying GPU availability.
  - **Upgrading GPU drivers & CUDA versions**: With **rolling updates**.
  - **Modifying Kubernetes deployments**:
    - Changing **replica counts**.
    - Updating **container images**.
  - **Storage-related changes**:
    - Expanding PersistentVolumes without downtime.

- **Follow-ups:**
  - What cluster modifications require a **full rebuild**?
  - How do you upgrade Kubernetes **without downtime**?
  - What role does **Terraform apply behavior** play in cluster stability?

- **Hints if struggling:**  
  - "What changes are safe in a production GPU cluster?"
  - "When do you need a rolling update vs recreating resources?"

---

## **6. How do you set up and manage different networking types in a GPU cluster?**
- **Expected Answer:**
  - **Control Plane Networking**:
    - Ensures Kubernetes API communication.
    - Uses **private clusters** to restrict access.
  - **Interconnect/Infiniband**:
    - Used for **distributed ML training** to enable fast GPU-to-GPU transfers.
  - **Service Mesh (Istio/Linkerd)**:
    - Adds observability, security, and traffic control.
  - **Load Balancing**:
    - Configuring **Ingress controllers** for model serving.

- **Follow-ups:**
  - What’s the role of **RDMA networking** in ML training?
  - When would you prefer **Pod IP-based networking vs Service Mesh**?
  - How do you diagnose **network bottlenecks** affecting GPU workloads?

- **Hints if struggling:**  
  - "How does networking impact multi-node ML training?"
  - "What’s the advantage of Infiniband over traditional Ethernet?"

---

## **7. What metrics are most important when monitoring a GPU cluster?**
- **Expected Answer:**
  - **GPU Utilization Metrics**:
    - **`DCGM_FI_DEV_GPU_UTIL`** → GPU load.
    - **`DCGM_FI_DEV_FB_USED`** → Memory usage.
  - **CPU-to-GPU Bottlenecks**:
    - Check **CPU utilization** to ensure data feeding isn’t slow.
  - **Networking Performance**:
    - Measure **inter-GPU communication latency**.
  - **Disk I/O & Storage Throughput**:
    - Monitor **PVC read/write speeds** for dataset loading.

- **Follow-ups:**
  - How would you detect and fix **GPU memory fragmentation**?
  - What’s the correlation between **GPU and network utilization**?
  - How do you track GPU health to predict failures?

- **Hints if struggling:**  
  - "How do you measure whether GPUs are fully utilized?"
  - "What external factors can impact GPU workload performance?"

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

## Carl Questions:

- how do you set up MIG configuration in K8s, or is that something that gets configured at a level lower than K8s?
- how do you allocate contiguous GPUs for optimizing training? How do you allocate workloads to contiguous GPUs?
- how do you set up the different networks (interconnect, infiniband, control plane, etc)
- What metrics are most important in monitoring the health of the cluster?  When troubleshooting, what correlations do you - look for between different metrics? (ie. CPU / GPU, GPU / interconnect / network, etc)
- Probably don't need to test on inference questions at this point in time, unless there's extra time left in the interview
- What kinds of cluster changes can be done without causing K8s to tear down the whole cluster and rebuild? (probably a terraform question)
- What IaC tooling do you prefer and why? (ie. terraform, pulumi, gcloud, etc)