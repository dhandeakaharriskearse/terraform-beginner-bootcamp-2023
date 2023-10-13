# Terraform Beginner Bootcamp 2023 - Week 1

- [Terraform Beginner Bootcamp 2023 - Week 1](#terraform-beginner-bootcamp-2023---week-1)
  * [Fixing Tags](#fixing-tags)
  * [Root Module Structure](#root-module-structure)
  * [Terraform Variables](#terraform-variables)
    + [Terraform Cloud Variables](#terraform-cloud-variables)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
      - [var flag](#var-flag)
      - [var-file flag](#var-file-flag)
      - [terraform.tfvars](#terraformtfvars)
      - [auto.tfvars](#autotfvars)
      - [order of terraform variables](#order-of-terraform-variables)
  * [Dealing with Configuration Drift](#dealing-with-configuration-drift)
    + [What happens if you lose your state file?](#what-happens-if-you-lose-your-state-file-)
    + [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
    + [Fix Manual Configuration](#fix-manual-configuration)
    + [Fix jusing Terraform Refresh](#fix-jusing-terraform-refresh)
  * [Terraform Modules](#terraform-modules)
    + [Terraform Module Structure](#terraform-module-structure)
    + [Passing Input Variables](#passing-input-variables)
    + [Module Sources](#module-sources)
  * [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
  * [Working with files in Terraform](#working-with-files-in-terraform)
    + [fileexists function](#fileexists-function)
    + [filemd5 function](#filemd5-function)
    + [Path Variable](#path-variable)
    + [Terraform locals](#terraform-locals)
    + [Terraform Data Sources](#terraform-data-sources)
  * [Working with JSON](#working-with-json)
    + [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
  * [Terraform Data](#terraform-data)
  * [Provisioners](#provisioners)
    + [local-exec](#local-exec)
    + [remote-exec](#remote-exec)
  * [For Each Expressions](#for-each-expressions)

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

We can use the `-var` tag to input a variable or override a variable in the .tfvars file eg. 
```sh
terraform -var user_uuid="my-user-uuid"
```

#### var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with `-var-file` tag.
```sh
terraform apply -var-file="testing.tfvars"
```

#### terraform.tfvars

`terraform.tfvars` is a file used in Terraform to store variable values that you want to use in your Terraform configurations. 
This file is particularly useful when you're working with Terraform Cloud or Terraform Enterprise, as it allows you to separate sensitive or environment-specific data from your main Terraform code.

You can use `terraform.tfvars` to configure your Terraform projects for deploying infrastructure in these technologies in a more organized and secure manner.

#### auto.tfvars

If you create a file named `auto.tfvars` in your Terraform Cloud workspace, you can define variable values in this file, and Terraform will automatically use them when you run your infrastructure provisioning or update commands within that workspace.

The "auto" part means that Terraform will automatically load variable values from these files without requiring explicit flags or command-line options.

```tf
# auto.tfvars

my_variable = "my_value"
another_variable = 42

```

#### order of terraform variables

Terraform uses a specific order of precedence when determining the value of a variable. If the same variable is assigned multiple values, Terraform will use the value of highest precedence, overriding any other values. 

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

 1. Environment variables (TF_VAR_variable_name)
 2. The terraform.tfvars file
 3. The terraform.tfvars.json file
 4. Any .auto.tfvars or .auto.tfvars.json files, processed in lexical order of their filenames.
 5. Any -var and -var-file options on the command line, in the order they are provided.
 6. Variable defaults

![tf_variable_precedence](https://github.com/dhandeakaharriskearse/terraform-beginner-bootcamp-2023/assets/110075236/06280431-3ae6-4339-8bbc-e849cfb1e37c)
- credit to Tanushree Aggarwal for this graphic representation

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
module "terrahome_aws" {
  source = "./modules/terrahome_aws"
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
module "terrahome_aws" {
  source = "./modules/terrahome_aws"
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

## Provisioners

Provisioners allow you to execute commands on compute instances (eg. an AWS CLI command)

They're not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### local-exec

This will execute a command on the machine running terraform commands (eg. plan, apply)

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```
[local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### remote-exec

This will execute a command on the machine that you target. You will need  to provide credentials such as ssh to gain access to the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

```
[remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## For Each Expressions

For expressions can be used when iterating over a data type
[for Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

For each allows us to enumerate over complex data types
```sh
[for s in var.list : upper(s)]
```
This is mostly useful when creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

"for_each is a meta-argument defined by the Terraform language. The for_each meta-argument accepts a map or a set of strings, and creates an instance for each item in that map or set. Each instance has a distinct infrastructure object associated with it, and each is separately created, updated, or destroyed when the configuration is applied."
[The for_each Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
