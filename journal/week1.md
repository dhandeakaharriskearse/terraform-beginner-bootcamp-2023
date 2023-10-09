# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Variables

### Terraform Cloud Variables

In terraform we can set 2 kinds of variables:

- **Environment Variables** - Environment variables can be used to store sensitive information or configuration settings, which may include API keys, access tokens, or any data that shouldn't be hard-coded for security reasons eg. AWS credentials

- **Terraform Variables** - Terraform variables allow you to define values that can be used in your Terraform configurations, making them dynamic and reusable. These variables would normally be set in the .tfvars file.

Terraform variables can be set to sensitive so they're not shown visibly in th UI

### Loading Terraform Input Variables
[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

#### var flag

We can use the `-var` tag to input a variable or override a variable in the .tfvars file eg. `terraform -var user_uuid="my-user-uuid"`

#### var-file flag

- TODO: document this flag

#### terraform.tfvars

This is the default file to load in terraform variables in bulk

#### auto.tfvars

- TODO: document this functionality for terraform cloud

#### order of terraform variables
- TODO: document which terraform variables take precedence

## Dealing with Configuration Drift

### What happens if you lose your state file?

You will most likely have to tear down all your cloud infrastructure manually. 

You can use terraform import, but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform inport was_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If cloud resources are deleted or modified manually through ClickOps.

Running `terraform plan` will attempt to put our infrastructure back into the excpected state, fixing configuration drift.

