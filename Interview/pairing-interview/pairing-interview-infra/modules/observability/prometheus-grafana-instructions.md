## To view Grafana using Prometheus metrics you need to

1. Find the Grafana pod on the cluster using a tool like k9s or enter the command:
```
kubectl get pods -n observability | grep grafana
```

2. Forward a port on the service to allow you to access. Use k9s for this or run the command:

```
kubectl port-forward -n observability prometheus-grafana-5b5684fb65-8txb2 3000 #replace pod name with your own
```

3. Go to localhost:3000 and use the login credentials:
	- Username: admin
	- Password: Message Matt For Password

4.	Navigate to Configuration → Data Sources.
    - Add a new data source:
    - Choose Prometheus.
    - Set the URL to: ```
http://prometheus-kube-prometheus-prometheus.observability:9090/```
    - 	Click Save & Test.


## Recreating the GPU-Dashboard

*** This is temporary while I automate the provisioning of Grafana ***

1. Go to the ```dashboards``` subdirectory
  - Open ```gpu-dashboard.yaml```
  - Copy the yaml to clipboard
2. Go to Grafana -> Dashboards -> Dashboard Settings -> Json Model
  - Paste the yaml file into the textbox
  - Save changes