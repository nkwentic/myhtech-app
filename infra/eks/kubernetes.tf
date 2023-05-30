provider "kubernetes" {
  config_context_cluster = var.eks_cluster_name
}

resource "kubernetes_namespace" "finance_app" {
  metadata {
    name = "finance-app"
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace.finance_app.metadata[0].name
    labels = {
      app = "finance"
      tier = "frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "finance"
        tier = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "finance"
          tier = "frontend"
        }
      }

      spec {
        container {
          name = "frontend"
          image = "YOUR-DOCKER-IMAGE-URL-HERE"
          ports {
            container_port = 80
          }
          env {
            name = "DB_HOST"
            value = "database.host.com"
          }
          env {
            name = "DB_USER"
            value = "db_user"
          }
          env {
            name = "DB_PASSWORD"
            value = "db_password"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace.finance_app.metadata[0].name
  }

  spec {
    selector = {
      app = "finance"
      tier = "frontend"
    }

    port {
      name = "http"
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
