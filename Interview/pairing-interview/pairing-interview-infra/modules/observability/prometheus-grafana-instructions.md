## To view Grafana using Prometheus metrics you need to

1. Find the Grafana service on the cluster using a tool like k9s.

2. Forward a port on the service to allow you to access. Use k9s for this or run the command:

```
kubectl port-forward -n observability svc/prometheus-grafana 3000:80
```

3. Go to localhost:3000 and use the login credentials:
	- Username: admin
	- Password: Message Matt For Password

4.	Navigate to Configuration → Data Sources.
    - Add a new data source:
    - Choose Prometheus.
    - Set the URL to: ```
http://prometheus-server.observability.svc.cluster.local```
    - 	Click Save & Test.


## Creating a Custom Dashboard

1. Click the **“+”** icon on the left sidebar.
2. Select **“Dashboard”** → Click **“Add a new panel”**.
3. In the **Query Section**, select `Prometheus` as the data source.
4. Use one of the following example queries to monitor GPU usage:
   - **GPU Utilization**
     \```promql
     DCGM_FI_DEV_GPU_UTIL{instance=~".*"}
     \```
   - **Memory Utilization**
     \```promql
     DCGM_FI_DEV_FB_USED{instance=~".*"} / DCGM_FI_DEV_FB_TOTAL{instance=~".*"} * 100
     \```
   - **Active Processes on GPUs**
     \```promql
     DCGM_FI_DEV_PROCESS_COUNT
     \```
5. Click **Save**, provide a name, and assign it to a folder.

Now, your dashboard should be live and showing GPU utilization metrics. 🚀