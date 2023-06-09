# Adding self-managed Kubernetes clusters to HCP Consul

## Prerequisites

1. Create a GCP project.

   1. Enable the following APIs for the project:
      - Service Usage API
      - Kubernetes Engine API
      - IAM Service Account Credentials API

   1. Create a service account for Terraform with the following
      roles:
      - Editor
      - Kubernetes Engine Admin

1. Create an HCP account.

1. Create a Terraform Cloud organization.

1. Download [consul-k8s](https://github.com/hashicorp/consul-k8s/tree/main#cli).

## Bootstrap TFC Workspaces

Go to `gcp/bootstrap`.

Define all required variables in `terraform.auto.tfvars`.

Run `terraform init`.

Run `terraform apply`.

This creates a set of three workspaces:

1. cluster
1. services
1. consul

And a variable set for GCP credentials that applies to all three workspaces.
It also sets up VCS connections within each workspaces to point to the working
directory of your fork.

## Create GKE cluster

1. Go to `gcp/cluster`.

1. Define the variables in `variables.tf`.

1. Set GCP credentials as environment variables with the service
   account credentials.
   - `GOOGLE_CREDENTIALS`

1. Run Terraform to create the cluster.

## Deploy HCP Consul to GKE cluster

> Note: We cannot use the Consul Helm chart to link a self-managed
> cluster to HCP because you need to generate a series of bootstrap
> tokens using the HCP API. This ensures that HCP Consul has proper
> access to the cluster with least-privilege ACL policies.

1. Go to the "Consul" tab in your HCP project.

1. Select "Self-Managed Consul".

1. Set up cluster details.

1. The next view should have a CLI command for `consul-k8s`.
   Copy this CLI command and save it somewhere.

1. Set your `kubectl` locally to point to your GKE cluster.

   ```shell
   gcloud container clusters get-credentials service-mesh-at-scale --region us-central1-a
   ```

1. Set the following environment variables generated by the CLI command you copied
   from HCP Consul.
   ```shell
   export HCP_CLIENT_ID=${CLIENT_ID}
   export HCP_CLIENT_SECRET=${CLIENT_SECRET}
   export HCP_RESOURCE_ID=${RESOURCE_ID}
   ```

1. Run the consul deploy script.
   ```shell
   bash consul.sh
   ```

1. Navigate to the HCP Consul dashboard to examine your self-managed cluster.
   If you want to access the Consul cluster, you can retrieve the address
   and token from `consul.json`.

## Deploy services to GKE Cluster

After deploying Consul, use Terraform to deploy
the services under `gcp/services`.

## Configure services for Consul

Configure the services to connect to other services in peers.
Use Terraform to apply the configuration under `gcp/consul`.