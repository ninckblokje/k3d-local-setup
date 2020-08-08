Write-Host "Setting up K3D"
k3d.exe create -w 1

Write-Host "Waiting for K3D"
Start-Sleep -Seconds 15

$env:KUBECONFIG=(k3d get-kubeconfig)
$env:HELM_HOME="$env:KUBECONFIG\..\helm"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kubectl apply -f dashboard.admin-user-role.yml
kubectl apply -f dashboard.admin-user.yml

Write-Host "Admin token:"
(kubectl -n kubernetes-dashboard describe secret admin-user-token) -match 'token:' -replace '^token:      ' > "$env:KUBECONFIG\..\token.txt"
Get-Content "$env:KUBECONFIG\..\token.txt"

Write-Host "K3D finished"