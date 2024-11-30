# Article CMS (FlaskWebProject)

This project is a Python web application built using Flask. The user can log in and out and create/edit articles. An article consists of a title, author, and body of text stored in an Azure SQL Server along with an image that is stored in Azure Blob Storage. You will also implement OAuth2 with Sign in with Microsoft using the `msal` library, along with app logging.

## Set up

In this project, we will use github action flow and Terraform to build the infratructure and deploy the applicatiuon automatically, to use the workflow, you should set up all the secret below:

  - The app registration should have the Contributor role, and GitHub federated access should be set up for the repository repo:wanghongran2023/Azure-CMS-for-articles:environment:Production. 
  - After running the Infrastructure construction workflow, you will get the storage account access key, which should be set as the STORAGE_KEY secret.

| Secret Name | Content |
|----------|----------|
| 1. TENANT_ID 			| Microsoft Entra ID -> Tenant ID |
| 2. SUBSCRIPTION_ID		| Subscriptions -> Subscriptions ID |
| 3. SP_CLIENT_ID		| Application -> Application (client) ID |
| 4. SP_CLIENT_SECRET	        | Application Secret -> Value |
| 5. SP_CLIENT_SECRET_KEY	| Application Secret -> Secret ID |
| 6. RESOURCE_GROUP_LOCATION	| Location for resource group, like west US |
| 7. RESOURCE_GROUP_NAME	| Name for resource group |
| 8. DB_SERVER_NAME		| Name for DB Server |
| 9. DB_SERVER_USER		| Account used to access DB Server |
| 10. DB_SERVER_PASSWORD	| Password used to access DB Server |
| 11. DB_NAME			| Name for DB |
| 12. STORAGE_CONTAINER		| Name for Blob Container |
| 13. STORAGE_ACCOUNT		| Name for Storage Account |
| 14. STORAGE_KEY		| Access key for Storage Account |
| 15. APP_NAME			| Name for App service |

## Deploy Infra

Run the Infrastructure Construction Workflow. This workflow will use GitHub secrets to update Terraform variables and deploy the storage account, database, resource group, and app services to Azure

## Deploy App

Run the App Deploy Workflow. This workflow will use GitHub secrets to update App variables and deploy the app to Azure App Services
