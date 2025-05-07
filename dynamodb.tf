resource "aws_dynamodb_table" "dynamodbtable" {
  name             = var.dynamodb_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "state"
  range_key        = "zip"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "state"
    type = "S"
  }

  attribute {
    name = "zip"
    type = "S"
  }
}