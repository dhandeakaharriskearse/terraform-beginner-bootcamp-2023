# Terraform Beginner Bootcamp 2023 - Week 0

## Table of Contents 

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  - [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
	- [Shebang Considerations](#shebang-considerations)
		- [Execution Considerations](#execution-considerations)
		- [Linux Permissions Considerations](#linux-permissions-considerations)
  - [Github Lifecycle (Before, Init, Command)](#github-lifecycle-before-init-command)
	- [Working with Env Vars](#working-with-env-vars)
		- [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
		- [Printing Env Vars](#printing-env-vars)
		- [Scoping of Env Vars](#scoping-of-env-vars)
		- [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
	- [Terraform Registry](#terraform-registry)
	- [Terraform Console](#terraform-console)
		- [Terraform Init](#terraform-init)
		- [Terraform Plan](#terraform-plan)
		- [Terraform Apply](#terraform-apply)
		- [Terraform Destroy](#terraform-destroy)
		- [Terraform Lock Files](#terraform-lock-files)
		- [Terraform State Files](#terraform-state-files)
		- [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and GitPod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning 

This project is going to utilize semantic versioning for its tagging
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed to refer to the latest CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution
This project is built against Ubuntu.
Please consider checking you Linux Distribution and change according to your distribution needs.

[How To Check Linux OS Version](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version

```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts
While fixing the Terraform CLI gpg deprecation issues we noticed the bash script steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here:[./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task file ([.gitpod.yml](.gitpod.yml)) tidy.
- This will allow us an easier to debug and execute manually Terraform CLI install.
- This will allow better portablity for other projects that need to install Terraform CLI.

### Shebang Considerations
A Shebang (pronounced Sha-bang) tells the bash script what program will interpret the script. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- For portability of different OS distributions
- Will search for the user's PATH for the bash executable
https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations
When executing the bash script we can use the `./` shorthand notation to execute the bash script

eg. `./bin/install_terraform_cli`

If we are using a script in gitpod.yml we need to point the script to a program to interpret it

eg. `source ./bin/install_terraform_cli`


#### Linux Permissions Considerations

In order to make our bash scripts executable, we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```
Alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```
https://en.wikipedia.org/wiki/Chmod


### Github Lifecycle (Before, Init, Command)
We need to be careful when using the Init because it will not rerun if we restart an existing workspace. 

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars
We can list out all enviroment variables (env vars) using the `env` command

We can filter specific env vars using "grep" eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using _"export VARNAME"_ eg. `export HELLO= 'world'` 

In the terminal we can unset using _"unset VARNAME"_ eg. `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO= 'world' ./bin/print_message
```

Wtihnin a bash script we can set an env without writing "export" eg.

```sh
#!/usr/bin/env bash

HELLO= 'world'

echo $HELLO
```

#### Printing Env Vars
We can print an env var using "echo" eg. `echo $HELLO`

#### Scoping of Env Vars
When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want env vars to persist across all future bash terminals that are open you need to set env vars in your bash profile eg. `.bash_profile`

#### Persisting Env Vars in Gitpod
We can persist env vars into Gitpod by storing them in Gitpod  Secrets Storage.

```sh
gp env HELLO= 'world'
```

All future workspaces launched will set the env env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars. 

## AWS CLI Installation
AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIDPYUBTVKFSAPZDKUGLV",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM User in order to use the AWS CLI

## Terraform Basics

### Terraform Registry
Terraform sources their providers and modules from the Terraform registry.
It's located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are plugins or extensions that allow Terraform to interact with various cloud providers, infrastructure platforms, and services. 
    - They serve as the bridge between your Terraform configuration and the APIs of the target infrastructure or service you want to manage.

    [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

- **Modules** are a way to organize, encapsulate, and reuse sections of Terraform configurations. 
    - They allow you to break down your infrastructure code into smaller, manageable units, making it easier to maintain and reuse code across different projects or environments.
    - Modules are especially helpful when working on complex infrastructure setups or when collaborating with others on Terraform projects.

### Terraform Console
We can see a list of all the Terraform commands by typing `terraform`.

#### Terraform Init
Providers are implemented as plugins in Terraform. Terraform automatically downloads and installs the necessary provider plugins when you initialize a Terraform project using the `terraform init` command.


#### Terraform Plan 
The `terraform plan` command in Terraform is used to preview the changes that will be made to your infrastructure when you apply your Terraform configuration. 
- It provides valuable information about what Terraform intends to do without actually making any changes to the infrastructure. 

#### Terraform Apply
Once you review the plan and are satisfied with the proposed changes, you can use the `terraform apply` command to apply those changes and make them effective in your infrastructure.

- Apply should prompt "yes" or "no"
- To automatically approve changes, apply the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy
The `terraform destroy` command in Terraform is used to destroy (delete) all the resources and infrastructure that were created and managed by a Terraform configuration. 
- It essentially tears down the entire infrastructure that was provisioned using the terraform apply command, reverting the environment to its original state or to a state defined by the Terraform configuration.
- You can also use the auto apply flag to skip the prompt eg. `terraform destroy --auto-approve`

#### Terraform Lock Files
`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VCS) eg. GitHub

#### Terraform State Files
`.terraform.tfstate` contains information about the current state of your infrastructure.

- This file **should not be committed** to your VCS. This file can contain sensitive data.
- If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous file state.

#### Terraform Directory
`.terraform` contains binaries of terraform providers.


## Issues with Terraform Cloud Login and GitPod Workspace
While following along with the Week O project prep, I attempted to run the `terraform login` command. It launched a wiswig view to generate a token. However, it doesn't work as expected in Gitpod VSCode in the browser.

The workaround it to manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```
Then create and open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```
Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR_TERRAFORM_CLOUD_API_TOKEN"
    }
  }
}
```
The process has been automated with the following bash script [./bin/generate_tfrc_credentials](./bin/generate_tfrc_credentials)

