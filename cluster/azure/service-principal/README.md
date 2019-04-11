# Service Principals and Terraform Deployment

Deploying Bedrock on Azure makes use of Service Princiapals.  Depending on the environment deployed, the Service Principal may require different permission levels or role assignments.  If the service principal being used has `Owner` privileges on the subscription, nothing special needs to be done.  For more inormation about Service Principals, RBAC and roles check [here](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview).

This document describes a set of tools and requirements necessary to deploy infrastructure in various environments.  Cases addressed include:

- Service principal can be created that has ownership privileges on the subscription
- Service principal will be created with limited privileges within the subscription

Additionally, a separation of service principals will be highlighted, specifically a deployment service principal and an AKS service principal. 

## Determining Azure CLI User Role on Subscription

To drive the other sections of the discussion, the role of the user within the subscription will drive what service principal scenarios are possible.  It is assumed that the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) is being used and logged into.  To determine the roles currently available to the logged in user, there is a [script](./scripts/determin_user_subscription.sh) to do such.

For example, running the script locally might look like:

```bash
$ ./determine_user_subscription_roles.sh 
User roles for jaspring@microsoft.com on subscription 1234bca0-abcd-44bd-7da2-4bb1e9fa9876: 
    - Owner
    - Contributor
jaspring@microsoft.com has Owner level privileges on subscription.
```

## Creating a Service Principal with `Owner` Privileges


## Creating a Service Principal with `Contributor` on One or More Resource Groups

