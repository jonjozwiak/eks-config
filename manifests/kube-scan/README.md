= Kube-scan

https://github.com/octarinesec/kube-scan

kubectl apply -f https://raw.githubusercontent.com/octarinesec/kube-scan/master/kube-scan.yaml
kubectl port-forward --namespace kube-scan svc/kube-scan-ui 8080:80

Go to http://localhost:8080 in your browser
