resource "kubernetes_manifest" "serviceaccount_customers" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "customers"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "service_customers" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "customers"
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
        "app" = "customers"
      }
    }
  }
}

resource "kubernetes_manifest" "servicedefaults_customers" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = "customers"
      "namespace" = "default"
    }
    "spec" = {
      "protocol" = "http"
    }
  }
}

resource "kubernetes_manifest" "deployment_customers" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "customers"
      }
      "name"      = "customers"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "customers"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "customers"
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
                  "value" = "coffee-customers"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "The customers of coffee that runs on Google Cloud"
                }
              ]
              "image" = "nicholasjackson/fake-service:v0.25.1"
              "name"  = "customers"
              "ports" = [
                {
                  "containerPort" = 9091
                },
              ]
            },
          ]
          "serviceAccountName" = "customers"
        }
      }
    }
  }
}
