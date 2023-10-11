# Terraform Beginner Bootcamp 2023 - Week 2

- [Terraform Beginner Bootcamp 2023 - Week 2](#terraform-beginner-bootcamp-2023---week-2)
  * [Working with Ruby](#working-with-ruby)
    + [Bundler](#bundler)
      - [Install Gems](#install-gems)
      - [Executing Ruby scripts in the context of bundler](#executing-ruby-scripts-in-the-context-of-bundler)
      - [Sinatra](#sinatra)
  * [Terratowns Mock Server](#terratowns-mock-server)
    + [Running the web server](#running-the-web-server)
  * [How to write Go code](#how-to-write-go-code)
  * [Writing Custom Terraform Providers](#writing-custom-terraform-providers)
    + [CRUD](#crud)

## Working with Ruby

### Bundler

Bundler is a package manager for Ruby.
It is the primary way to install Ruby packages (known as gems) for Ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file. 

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command.

This will install the gems on the system globally (unlike nodejs which installs packages in place in a floder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this projects.

#### Executing Ruby scripts in the context of bundler

We have to use `bundle exec` to tell future Ruby script to use the gems we installed. This is the way we set context.

#### Sinatra

Sinatra is a micro web framework for ruby to build web apps.
It's great for mock or development servers or for very simple projects.
You can creat a webserver in a single file.

[Sinatra Website](https://sinatrarb.com/)

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## How to write Go code

[GoLang Documentation](https://go.dev/doc/code)

## Writing Custom Terraform Providers
[Custom TF Providers](https://www.hashicorp.com/blog/writing-custom-terraform-providers)

### CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for Create, Read Update, and Delete

[CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)