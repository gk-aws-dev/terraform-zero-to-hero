Terraform modules are reusable packages of Terraform configurations that are used to organize and encapsulate infrastructure resources. 
Modules help in abstracting common patterns, making configurations more modular, and promoting code reuse. 
They allow you to package infrastructure components into reusable building blocks, making it easier to manage complex infrastructure setups.

Here's how you can use Terraform modules:

1. **Creating a Module**:
You create a Terraform module by organizing your configuration files into a directory. This directory should contain at least one .tf file with 
the Terraform configuration. You can organize your modules in a way that makes sense for your project's structure.

For example, let's create a simple module named example:

example/
  ├── main.tf
  ├── variables.tf
  └── outputs.tf

  
2. **Defining Resources in the Module**
Inside the main.tf file of your module, define the resources you want to include in the module. You can use variables to parameterize 
the resources and outputs to expose information from the module.

Example main.tf:

```
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```
3. **Declaring Variables and Outputs**
Define the input variables and outputs in variables.tf and outputs.tf files respectively.

Example variables.tf:
```
variable "ami_id" {
  description = "The AMI ID for the instance"
}
```
variable "instance_type" {
  description = "The instance type for the instance"
}
Example outputs.tf:
```
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
```
4. **Using the Module**
You can use the module you created in your Terraform configurations by calling it in your root module. You specify the module's source as a 
local directory or a remote Git repository.

Example usage in the root module:

```
module "example" {
  source = "./example"

  ami_id        = "ami-12345678"
  instance_type = "t2.micro"
}
```
5.**Running Terraform Commands**
Now, you can use Terraform commands (init, plan, apply, etc.) as usual in your root module directory. Terraform will automatically load 
the module and use it to provision the specified resources.

bash
Copy code
terraform init
terraform plan
terraform apply
Example Scenario:
Let's say you have a module named webserver that provisions an EC2 instance for hosting a web server. You can use this module in your main 
Terraform configuration to create multiple instances across different availability zones or regions.

```
module "webserver_us_east_1" {
  source = "./modules/webserver"

  ami_id        = "ami-12345678"
  instance_type = "t2.micro"
  region        = "us-east-1"
}

module "webserver_us_west_2" {
  source = "./modules/webserver"

  ami_id        = "ami-87654321"
  instance_type = "t2.micro"
  region        = "us-west-2"
}
```
In this example, you're using the webserver module twice to create EC2 instances in different regions (us-east-1 and us-west-2). 
Each instance is configured with its own specific AMI ID and instance type.

This modular approach makes it easy to manage and scale infrastructure configurations, promoting code reuse and maintainability.
