provider "consul" {
  address    = hcp_consul_cluster.main.consul_public_endpoint_url
  datacenter = hcp_consul_cluster.main.datacenter
  token      = hcp_consul_cluster_root_token.token.secret_id
}

resource "consul_acl_auth_method" "azure_jwt" {
  depends_on = [hcp_consul_cluster.main]

  name = "azure-jwt"
  type = "jwt"
  config_json = <<EOF
{
  "BoundAudiences": [
    "https://management.azure.com/"
  ],
  "BoundIssuer": "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/",
  "JWKSURL":"https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}/discovery/v2.0/keys",
  "ClaimMappings": {
      "id": "xms_mirid"
  }
}
  EOF
}