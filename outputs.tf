output "project_id" {
  value = local.project_id
}

output "attacker_service_account_email" {
  value = google_service_account.attacker.email
}

output "target_admin_service_account_email" {
  value = google_service_account.target_admin.email
}
