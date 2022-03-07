terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

data "google_project" "default" {
  project_id = var.project_id
}

###############################################################################
# Secrets
###############################################################################

resource "google_secret_manager_secret" "default" {
  secret_id = "domo-config"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "default" {
  secret_id = google_secret_manager_secret.default.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.default.number}-compute@developer.gserviceaccount.com"
}

###############################################################################
# Cloud Run
###############################################################################

resource "google_cloud_run_service" "default" {
  name     = "domo-run"
  location = "us-east4"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        volume_mounts {
          name       = "config-volume"
          mount_path = var.config_mount_path
        }
      }
      volumes {
        name = "config-volume"
        secret {
          secret_name = google_secret_manager_secret.default.secret_id
          items {
            key  = "latest"
            path = var.config_file_name
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      template[0].spec[0].containers[0].env,
    ]
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
