resource "google_service_account_iam_member" "attacker_can_create_keys_for_target_admin" {
  service_account_id = google_service_account.target_admin.name
  role               = "roles/iam.serviceAccountKeyAdmin"
  member             = "serviceAccount:${google_service_account.attacker.email}"
}

resource "google_project_iam_custom_role" "attacker_set_iampolicy_role" {
  project = local.project_id
  role_id = "attackerSetIamPolicy"
  title   = "Attacker: setIamPolicy"
  permissions = [
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy"
  ]
  stage = "GA"
}

resource "google_project_iam_member" "attacker_has_set_iampolicy" {
  project = local.project_id
  role    = google_project_iam_custom_role.attacker_set_iampolicy_role.name
  member  = "serviceAccount:${google_service_account.attacker.email}"
}
