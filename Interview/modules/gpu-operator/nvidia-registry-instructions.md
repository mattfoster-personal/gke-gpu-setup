add a secret for the nvcr.io registry and add it to whatever service account is running the installer (e.g. kube-system)

like so:
kubectl create secret docker-registry nvcr-secret  --docker-server=nvcr.io  --docker-username='$oauthtoken'  --docker-password='YOUR-API-KEY'  --namespace kube-system

kubectl patch serviceaccount default -n gpu-operator -p '{\n  "imagePullSecrets": [{"name": "nvcr-secret"}]\n}'\n