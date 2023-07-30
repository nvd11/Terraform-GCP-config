resource "google_bigquery_table" "table1" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "table1"
  project    = var.project_id
  schema = [
    {
      name = "staffid"
      type = "STRING"
    },
    {
      name = "name"
      type = "STRING"
    }
  ]
}

resource "google_bigquery_table" "table2" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "table2"
  project    = var.project_id
  schema = jsonencode({
    fields = [
      {
        name = "staffid"
        type = "STRING"
      },
      {
        name = "name"
        type = "STRING"
      }
    ]
  })
}