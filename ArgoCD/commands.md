# Installing Argo CD

1. Create a namespace for Argo CD:
kubectl create namespace argocd

2. Apply the Argo CD manifest:
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

3. Check services in Argo CD namespace:
kubectl get svc -n argocd

4. Expose Argo CD server using NodePort:
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

5. Forward ports to access Argo CD server:
kubectl port-forward -n argocd service/argocd-server 8443:443 &

6. Setup admin password using secrets.yml with base64 encryption:
# Install tool
s- udo apt-get install -y apache2-utils

# Generate base64 (Replace 'yourbase64' with your actual password)
Use the generated base64 into secret file.

7. Apply it to the cluster:
kubectl apply -f secret.yaml

8. Restart the ArgoCD Server
kubectl rollout restart deployment argocd-server -n argocd