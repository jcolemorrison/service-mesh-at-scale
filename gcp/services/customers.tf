resource "kubernetes_manifest" "serviceaccount_customers" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "coffee-customers"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "service_customers" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "coffee-customers"
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
        "app" = "coffee-customers"
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_customers" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "coffee-customers"
      }
      "name"      = "coffee-customers"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "coffee-customers"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "coffee-customers"
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
                  "value" = "coffee-customers-GCP"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "The customers of coffee that runs on Google Cloud"
                }
              ]
              "image" = "nicholasjackson/fake-service:v0.25.1"
              "name"  = "coffee-customers"
              "ports" = [
                {
                  "containerPort" = 9091
                },
              ]
            },
          ]
          "serviceAccountName" = "coffee-customers"
        }
      }
    }
  }
}
