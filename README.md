# AppSync Terraform DynamoDB example

An example [Terraform](https://www.terraform.io/) configuration to launch an [AWS AppSync](https://aws.amazon.com/appsync/) service with a DynamoDB data source.

> Note: the Makefile may only run on macOS/linux, if you are on Windows you may
> need to build the Go lambda function another way.

### About the contents of this repo:

- Apache Velocity resolver templates are inside the `/resolvers` directory
- The GraphQL schema is in `schema.graphql`
- All Terraform config is within the following 3 files:
  - `variables.tf` has variables used throughout the rest of the config
  - `iam.tf` contains AWS IAM roles and policies
  - `main.tf` contains the code for generating all other required services

### Before publishing:

1. [Download Terraform](https://www.terraform.io/downloads.html)
1. Have an existing local AWS credentials profile (this is required so Terraform has the permissions to publish your AWS service)
1. Open `variables.tf` and set them to whatever you want

> Note: if you want your state to persist, remove the line from `.gitignore` that says `*.tfstate`. This state is essential to keep track of your AWS resources in order to successfully update or destroy them.

### To publish:

Warning: this will fall within the free tier for AWS, however if you have had your account for longer than 1 year you may be charged a small amount for executing AppSync queries since the free tier for AppSync is only 12 months. If you still want to deploy it, the cost should be minimal (cents, not dollars).

1. Run `terraform init` to initialize terraform and fetch all the resources
1. Run `terraform plan` to view the diff and all the created resources
1. Run `terraform apply` to publish (it will prompt you to type "yes" to confirm)
1. Populate data to DynamoDB table: `aws dynamodb batch-write-item --request-items file://Destinations.json`

> Once this is done you can view your [AppSync console](https://console.aws.amazon.com/appsync/home) and run queries to test that the DynamoDB data source is working!

Example query:
```
query getState {
  getState(state: "Nevada", zip: "89108") {
    state
    zip
    city
    description {
      text
    }
  }
}
```

### To destroy

1. Run `terraform destroy` to remove all AWS services (it will prompt for "yes" again)