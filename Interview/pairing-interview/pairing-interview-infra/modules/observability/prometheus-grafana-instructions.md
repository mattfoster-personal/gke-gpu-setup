## To view Grafana using Prometheus metrics you need to

1. The ip ```34.151.254.75``` should be static but just to check, run: 
```
kubectl get svc -n observability
kubectl describe svc grafana -n observability
```

2. Obtain the external ip address for prometheus-grafana pod and put it into your browser


3. At login use credentials:
	- Username: admin
	- Password: Message Matt For Password

4.	If there is no Prometheus data source -> Navigate to Configuration → Data Sources.
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