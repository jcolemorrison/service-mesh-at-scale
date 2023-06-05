# Configuring authentication

## Azure

```shell
az login
```

## Configure HCP

Create a service principal in HCP, then export the following details

```shell
export HCP_CLIENT_ID=eANPsL23HCy51xxxxxxxxxxxxx
export HCP_CLIENT_SECRET=9CpbDFhjfOUZ3kLOdSC3jQL-XXXxxxXXxxXXXX
```

Create an sp for terraform

```
az ad sp create-for-rbac --role="Owner" \
   --scopes="/subscriptions/28af6932-cb76-431f-ba61-5ec6d1e8b422" \
   --name "Terraform Cloud (service-mesh-at-scale)" > azure.json
```

Add admin permissions to create other service principals

```
az ad app permission admin-consent --id=$(cat azure.json  | jq -r .appId)
```