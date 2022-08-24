# Liatrio Demo - Provision AKS Cluster

## Prerequisites

This deployment expects that application code exists in another git repo.  
In this case, the terraform variable 'containerSource' points to a repo containing a simple Flask API application.

You will need Azure CLI, Terraform, and kubectl.  If you'd like to modify the python app, make sure to have python and flask installed as well.

## Deploying the AKS Cluster

Clone this repository and change directory into it.  

Create a file called 'secret.tfvars' and save it in the root of the repository.  The contents of the file should look like this:

        sourcePAT = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Where sourcePAT is a PAT for your github repo.  Once this file is created, you can deploy the environment.

Run 'terraform init' and then 'terraform validate' to ensure there are no issues with the code itself.

Run 'terraform plan -var-file='secret.tfvars' -out=tfplan'.  Ensure there are no errors here, and then execute the apply command: 'terraform apply tfplan'.

When complete, you should be able to access the api endpoint with any browser, and you should receive this response:

        {"message":"Automate all the things!","timestamp":1661371038.0}

