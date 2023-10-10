# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How To Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

- Delete a local git tag
```sh
git tag -d <tag_name>
```

- Delete a remote Git tag
```sh
git push --delete origin tagname
```
Checkout the commit that you want to retag. Grab the SHA from your Github history

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

### Fix jusing Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to palce modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input cvariables into our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

[TF Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

Uisng the source we can import the module from various places. eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. This will often affect providers.

## Working with files in Terraform

### fileexists function

A built in terraform function to check the existence of a file.

```tf
condition     = fileexists(var.index_html_filepath)
```

[Function - fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### filemd5 function



[Function - filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the pathe for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag = filemd5("${path.root}/public/index.html")
}
```
### Terraform locals

Locals allows us to define local variables.
This is very helpful when we need to transform data from one format to another and have it referenced as a variable.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

A data source is accessed via a special kind of resource known as a data resource, declared using a data block:
```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

This is useful when we want to reference cloud resources without importing them.
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We used jsonencode to create the json policy inlinein the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}

```
[jsonencode Function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources


[The lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[The terraform_data Managed Resource Type](https://developer.hashicorp.com/terraform/language/resources/terraform-data)