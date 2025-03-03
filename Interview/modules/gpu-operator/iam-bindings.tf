resource "google_project_iam_binding" "cluster_admin_binding" {
  project = "ai-research-e44f"
  role    = "roles/container.clusterAdmin"

  members = [
    "user:mfoster@thoughtworks.com" # add users here
  ]
}
