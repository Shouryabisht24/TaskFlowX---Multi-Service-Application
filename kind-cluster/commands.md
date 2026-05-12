Terminal Command History for Kind Voting App

1. Install & configure Docker:
./install_docker.sh

2. Install kind
chmod 700 install_kind
./install_kind.sh

3. Install kubectl
chmod 700 install_kubectl
./install_kubectl.sh

4. Create a 3-node Kubernetes cluster using Kind:
kind create cluster --config=config.yml

5. Check cluster information:
kubectl cluster-info --context kind-kind
kubectl get nodes
kind get clusters