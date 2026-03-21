# Order_Date 's field type is changed to DATE
resource "google_bigquery_table" "sales_details_d" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_d"
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

}

# The field for partition must be one of the following types: DATE, Timestamp, or Integer. 
# otherwise :  Error: googleapi: Error 400: The field specified for time partitioning can only be of type TIMESTAMP, DATE or DATETIME. The type found is: STRING., invalid
resource "google_bigquery_table" "sales_details_p2" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_p2"
  project    = var.project_id
  deletion_protection = false
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
    # require_partition_filter = true  # must use partition filter
  }
}

resource "google_bigquery_table" "sales_details_p3" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_p3"
  project    = var.project_id
  deletion_protection = false
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
    //expiration_ms            = 2592000000  # set the expired days to 30
    //require_partition_filter = true  # must use partition filter
  }

  require_partition_filter = true  # must use partition filter
}

resource "google_bigquery_table" "sales_details_p4" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_p4"
  project    = var.project_id
  deletion_protection = false
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
    //expiration_ms            = 2592000000  # set the expired days to 30
    //require_partition_filter = true  # must use partition filter
  }

  require_partition_filter = true  # must use partition filter
}

resource "google_bigquery_table" "sales_details_p5" {
  dataset_id = google_bigquery_dataset.dataset1.dataset_id
  table_id   = "sales_details_p5"
  project    = var.project_id
  deletion_protection = false
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
    //require_partition_filter = true  # must use partition filter
  }
  require_partition_filter = true  # must use partition filter
}