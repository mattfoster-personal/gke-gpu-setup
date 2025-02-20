# Example: GPU Node Pool

## Overview
This example demonstrates how to provision a GPU-enabled node pool in an existing GKE cluster using the Terraform module.

## Prerequisites
- An existing GKE cluster
- Terraform installed (`>= 1.0`)
- Google Cloud CLI (`gcloud`)

## Usage
To apply this example, run the following commands:

```sh
terraform init
terraform apply -auto-approve
```

## To clean up resources
```sh
terraform destroy -auto-approve
```