resource "kubernetes_manifest" "serviceaccount_loyalty" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "loyalty"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "service_loyalty" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "loyalty"
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
        "app" = "loyalty"
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_loyalty" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "loyalty"
      }
      "name"      = "loyalty"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "loyalty"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "loyalty"
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
                  "value" = "loyalty-GCP"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "The loyalty program service that runs on Google Cloud "
                }
              ]
              "image" = "nicholasjackson/fake-service:v0.25.1"
              "name"  = "loyalty"
              "ports" = [
                {
                  "containerPort" = 9091
                },
              ]
            },
          ]
          "serviceAccountName" = "loyalty"
        }
      }
    }
  }
}
