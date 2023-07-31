resource "google_bigquery_table" "table1" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "table1"
  project    = var.project_id

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "staffid",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The staff id"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "the staff name"
  }
]
EOF

}