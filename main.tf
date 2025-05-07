terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Set the AWS credentials profile and region you want to publish to.
provider "aws" {
  profile = var.aws_credentials_profile
  region  = var.region
}

# --- AppSync Setup ---

# Create the AppSync GraphQL api.
resource "aws_appsync_graphql_api" "appsync" {
  name                = "${var.prefix}_appsync"
  schema              = file("schema.graphql")
  authentication_type = "API_KEY"

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.iam_appsync_role.arn
    field_log_level          = "ALL"
  }

  xray_enabled = true
}

# Create the API key.
resource "aws_appsync_api_key" "appsync_api_key" {
  api_id = aws_appsync_graphql_api.appsync.id
}

# Create data source in appsync from lambda function.
resource "aws_appsync_datasource" "destinations_datasource" {
  name             = "${var.prefix}_destinations_datasource"
  api_id           = aws_appsync_graphql_api.appsync.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AMAZON_DYNAMODB"
  dynamodb_config {
    table_name = var.dynamodb_table_name
  }
}

# resource "aws_appsync_resolver" "getData_resolver" {
#   api_id      = aws_appsync_graphql_api.appsync.id
#   type        = "Query"
#   field       = "getData"
#   data_source = aws_appsync_datasource.destinations_datasource.name

#   request_template  = file("./resolvers/request.vtl")
#   response_template = file("./resolvers/response.vtl")
# }

# resource "aws_appsync_resolver" "getDestinationsByState_resolver" {
#   api_id      = aws_appsync_graphql_api.appsync.id
#   type        = "Query"
#   field       = "getDestinationsByState"
#   data_source = aws_appsync_datasource.destinations_datasource.name

#   request_template  = file("./resolvers/getDestinationsByState_request.vtl")
#   response_template = file("./resolvers/getDestinationsByState_response.vtl")
# }

resource "aws_appsync_resolver" "getState" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "getState"
  data_source = aws_appsync_datasource.destinations_datasource.name

  request_template  = file("./resolvers/getState_request.vtl")
  response_template = file("./resolvers/getState_response.vtl")
}
