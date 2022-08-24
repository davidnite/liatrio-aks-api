# Liatrio Demo - Provision AKS Cluster

## Prerequisites

This deployment expects that application code exists in another git repo.  
In this case, the terraform variable 'containerSource' points to a repo containing a simple Flask API application.

You will need an Azure subscription, Azure CLI, Terraform, and kubectl.  If you'd like to modify the python app, make sure to have python and flask installed as well.

Within the Azure CLI, run the 'az account set' command to select your subscription.  Terraform will then use this for deployment.

## Deploying the AKS Cluster

Clone this repository and change directory into it.  

Create a file called 'secret.tfvars' and save it in the root of the repository.  The contents of the file should look like this:

        sourcePAT = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Where sourcePAT is a PAT for your github repo.  Once this file is created, you can deploy the environment.

Run 'terraform init' and then 'terraform validate' to ensure there are no issues with the code itself.

Run 'terraform plan -var-file='secret.tfvars' -out=tfplan'.  Ensure there are no errors here, and then execute the apply command: 'terraform apply tfplan'.


## The API Application

When the cluster finishes deploying, you will be able to access the API from any web browser.  Run 'kubectl get services' or check the Azure portal to get the public IP of the app.

You should be able to access the api endpoint with any browser, and you should receive this response:

        {"message":"Automate all the things!","timestamp":1661371038.0}

The Flask API is very simple, and returns the above message using this python function:

        def get_response():
            date_time = datetime.now()
            response = { 'message': 'Automate all the things!', 'timestamp': (time.mktime(date_time.timetuple())) }
            return jsonify(response)


## Cleaning Up

To clean up the application and associated infrastructure, you simply need to run this command: 'terraform destroy -var-file='secret.tfvars''

This will remove all of the Azure infrastructure from your subscription.
