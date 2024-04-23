resource "google_bigquery_table" "pod_log" {
  dataset_id = google_bigquery_dataset.dataset_k8s.dataset_id
  table_id   = "POD_LOG"
  project    = var.project_id

  schema = <<EOF
[
    {
        "name": "uuid",
        "type": "STRING"
    },
    {
        "name": "podName",
        "type": "STRING"
    },
    {
        "name": "nameSpace",
        "type": "STRING"
    },
    {
        "name": "podVersion",
        "type": "STRING"
    },
    {
        "name": "action",
        "type": "STRING"
    },
    {
        "name": "actionTime",
        "type": "TIMESTAMP"
    }
]
EOF

}

