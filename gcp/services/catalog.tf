resource "kubernetes_manifest" "serviceaccount_catalog" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "catalog"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "service_catalog" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "catalog"
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
        "app" = "catalog"
      }
    }
  }
}

resource "kubernetes_manifest" "servicedefaults_catalog" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = "catalog"
      "namespace" = "default"
    }
    "spec" = {
      "protocol" = "http"
    }
  }
}

resource "kubernetes_manifest" "deployment_catalog" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "catalog"
      }
      "name"      = "catalog"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "catalog"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "catalog"
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
                  "value" = "coffee-catalog"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "A catalog of coffees that runs on Google Cloud"
                }
              ]
              "image" = "nicholasjackson/fake-service:v0.25.1"
              "name"  = "catalog"
              "ports" = [
                {
                  "containerPort" = 9091
                },
              ]
            },
          ]
          "serviceAccountName" = "catalog"
        }
      }
    }
  }
}
