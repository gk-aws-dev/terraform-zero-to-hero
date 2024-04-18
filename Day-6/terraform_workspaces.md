# terraform workspaces

```
[root@ip-172-31-17-17 terraform]# terraform workspace -h
Usage: terraform [global options] workspace

  new, list, show, select and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace
[root@ip-172-31-17-17 terraform]# 

```
--------------------------------------------------------------------
```
[root@ip-172-31-17-17 terraform]# tree
.
├── main.tf
├── modules
│   └── ec2_instance
│       ├── main.tf
│       └── variables.tf
├── terraform.tfstate.d
│   ├── dev
│   └── stg
├── terraform.tfvars
└── variables.tf

5 directories, 5 files
```
-------------------------------------------------------------------
