# Liatrio Demo - Provision AKS Cluster

## Prerequisites

This deployment expects that application code exists in another git repo.  
In this case, the terraform variable 'containerSource' points to a repo containing a simple Flask API application.

You will need an Azure subscription, Azure CLI, Terraform, and kubectl.  If you'd like to modify the python app, make sure to have python and flask installed as well.

Within the Azure CLI, run the 'az account set' command to select your subscription.  Terraform will then use this for deployment.

If using the azure devops pipeline file, make sure to create a storage account and container to store your state file.

## Deploying the AKS Cluster

### CLI

Clone this repository and change directory into it.  

Create a file called 'secret.tfvars' and save it in the root of the repository.  The contents of the file should look like this:

        sourcePAT = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Where sourcePAT is a PAT for your github repo.  Once this file is created, you can deploy the environment.

Run 'terraform init' and then 'terraform validate' to ensure there are no issues with the code itself.

Run 'terraform plan -var-file='secret.tfvars' -out=tfplan'.  Ensure there are no errors here, and then execute the apply command: 'terraform apply tfplan'.

When running terraform from the CLI, the application will not be deployed automatically.  Run 'kubectl apply -f deploy.yaml' to deploy the app into the cluster.

### Pipeline

This README will not cover the usage of AzureDevOps, so some familiarity with the service is requried.  You will need the following:

1. A service connection to your Azure subscription (update the pipeline file with the name of your connection spn)
2. Library variable groups for your tfstate and github secrets
3. The Marketplace extension 'Replace Tokens' installed into your org 

The variable groups should be named tf_state, tf_vars, and secrets.  Use the .tkn files as a guide for naming the variables in the tf_state and secret groups, since these are used by the replace tokens step to inject secrets into ephemeral config files at runtime.  The tf_vars variable group should contain two variables:

- terraform_destroy (set to false)
- tf_in_automation (set to true)

You can use the terraform_destroy boolean to tell the pipeline to destroy your infrastructure by setting it to true and running the pipeline.


## The API Application

Assuming you used the ADO pipeline, when the cluster finishes deploying, you will be able to access the API from any web browser.  Run 'kubectl get services' or check the Azure portal to get the public IP of the app.

You should be able to access the api endpoint with any browser, and you should receive this response:

        {"message":"Automate all the things!","timestamp":1661371038.0}

The Flask API is very simple, and returns the above message using this python function:

        def get_response():
            date_time = datetime.now()
            response = { 'message': 'Automate all the things!', 'timestamp': (time.mktime(date_time.timetuple())) }
            return jsonify(response)


## Cleaning Up

### CLI
To clean up the application and associated infrastructure, you simply need to run this command: 'terraform destroy -var-file='secret.tfvars''

### Pipeline
Set the 'terraform_destroy' variable to true and run the pipeline

This will remove all of the Azure infrastructure from your subscription.
