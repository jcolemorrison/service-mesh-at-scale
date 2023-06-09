resource "kubernetes_manifest" "serviceaccount_catalog" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "coffee-catalog"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "service_catalog" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "coffee-catalog"
      "namespace" = "default"
    }
    "spec" = {
      "ports" = [
        {
          "port"       = 9091
          "targetPort" = 9091
        },
      ]
      "selector" = {
        "app" = "coffee-catalog"
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_catalog" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "coffee-catalog"
      }
      "name"      = "coffee-catalog"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "coffee-catalog"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "coffee-catalog"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LISTEN_ADDR"
                  "value" = "0.0.0.0:9091"
                },
                {
                  "name"  = "NAME"
                  "value" = "coffee-catalog-GCP"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "A catalog of coffees that runs on Google Cloud"
                }
              ]
              "image" = "nicholasjackson/fake-service:v0.25.1"
              "name"  = "coffee-catalog"
              "ports" = [
                {
                  "containerPort" = 9091
                },
              ]
            },
          ]
          "serviceAccountName" = "coffee-catalog"
        }
      }
    }
  }
}
