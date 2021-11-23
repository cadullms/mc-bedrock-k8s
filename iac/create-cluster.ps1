param
(
    $ResourceGroupName = "mc-bedrock-rg",
    $ClusterName = "mc-bedrock",
    $Location = "westeurope",
    $VNetName = "mc-bedrock-vnet"
)

Write-Host "Creating resources..."
az group create --name $ResourceGroupName --location $Location | Out-Null
$aksSubnetName = "aks-subnet"
$vnetId=(az network vnet create `
    --resource-group $ResourceGroupName `
    --name $VNetName `
    --address-prefixes 10.0.0.0/8 `
    --subnet-name $aksSubnetName `
    --subnet-prefix 10.240.0.0/16 `
    --query "newVNet.id" -o tsv)
$identity=(az identity create --resource-group $ResourceGroupName --name "$($ClusterName)-id") | ConvertFrom-Json
az role assignment create --assignee $identity.principalId --scope $vnetId --role "Network Contributor" | Out-Null
$subnetId=(az network vnet subnet show --resource-group $ResourceGroupName --vnet-name $VNetName --name $aksSubnetName --query id -o tsv)
Write-Host "Creating cluster..."
az aks create `
    --resource-group $ResourceGroupName `
    --name $ClusterName `
    --node-count 1 `
    --service-cidr 10.0.0.0/16 `
    --dns-service-ip 10.0.0.10 `
    --docker-bridge-address 172.17.0.1/16 `
    --vnet-subnet-id $subnetId `
    --enable-managed-identity `
    --assign-identity "$($identity.id)" `
    --network-plugin azure `
    --network-policy azure `
    --kubernetes-version "1.21.2" `
    --no-ssh-key | Out-Null