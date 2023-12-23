resource "google_bigquery_table" "sales_details" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details"
  project    = var.project_id

  schema = <<EOF
[
    {
        "name": "Order_ID",
        "type": "STRING"
    },
    {
        "name": "Product",
        "type": "STRING"
    },
    {
        "name": "Quantity_Ordered",
        "type": "INTEGER"
    },
    {
        "name": "Price_Each",
        "type": "FLOAT"
    },
    {
        "name": "Order_Date",
        "type": "STRING"
    },
    {
        "name": "Purchase_Address",
        "type": "STRING"
    }
]
EOF

}

# The field for partition must be one of the following types: DATE, Timestamp, or Integer. 
# otherwise :  Error: googleapi: Error 400: The field specified for time partitioning can only be of type TIMESTAMP, DATE or DATETIME. The type found is: STRING., invalid
resource "google_bigquery_table" "sales_details_p" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_p"
  project    = var.project_id

  schema = <<EOF
[
    {
        "name": "Order_ID",
        "type": "STRING"
    },
    {
        "name": "Product",
        "type": "STRING"
    },
    {
        "name": "Quantity_Ordered",
        "type": "INTEGER"
    },
    {
        "name": "Price_Each",
        "type": "FLOAT"
    },
    {
        "name": "Order_Date",
        "type": "DATE"
    },
    {
        "name": "Purchase_Address",
        "type": "STRING"
    }
]
EOF

 time_partitioning {
    type                     = "DAY"  # partitioning by Day
    field                    = "Order_Date"  # Use it as the partition field
    expiration_ms            = 2592000000  # set the expired days to 30
    require_partition_filter = true  # must use partition filter
  }
}