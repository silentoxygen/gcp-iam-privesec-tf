resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  create_project = var.existing_project_id == null
  project_id     = local.create_project ? "${var.project_name_prefix}-${random_id.suffix.hex}" : var.existing_project_id
}

resource "google_project" "lab" {
  count           = local.create_project ? 1 : 0
  project_id      = local.project_id
  name            = "GCP IAM PrivEsc Lab (${local.project_id})"
  billing_account = var.billing_account

  org_id    = var.org_id
  folder_id = var.folder_id
}

resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com"
  ])

  project            = local.project_id
  service            = each.value
  disable_on_destroy = false

  depends_on = [google_project.lab]
}

resource "google_project_iam_member" "bootstrap_owner" {
  project = local.project_id
  role    = "roles/owner"
  member  = "user:${var.bootstrap_user}"

  depends_on = [google_project_service.services]
}

resource "google_service_account" "attacker" {
  account_id   = "attacker"
  display_name = "Attacker identity (low-priv)"
  project      = local.project_id
  depends_on   = [google_project_service.services]
}

resource "google_service_account" "target_admin" {
  account_id   = "target-admin"
  display_name = "High-priv target SA"
  project      = local.project_id
  depends_on   = [google_project_service.services]
}

resource "google_project_iam_member" "target_admin_owner" {
  project = local.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.target_admin.email}"
}
