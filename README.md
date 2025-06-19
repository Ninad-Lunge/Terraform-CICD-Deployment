# CI/CD Pipeline with AWS CodePipeline, ECS, and ALB

This project sets up a complete CI/CD pipeline using AWS CodePipeline to deploy a containerized Flask application to Amazon ECS with an Application Load Balancer.

## Architecture

The infrastructure includes:

- VPC with public and private subnets
- Application Load Balancer (ALB)
- Amazon ECS Cluster with Fargate
- Amazon ECR Repository
- AWS CodePipeline with GitHub integration
- AWS CodeBuild for building Docker images
- AWS CodeDeploy for blue/green deployments

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed (v1.0.0+)
- GitHub repository with your Flask application
- GitHub personal access token with repo scope

## Project Structure

```
.
├── app/                    # Flask application
│   ├── app.py              # Main Flask application
│   ├── Dockerfile          # Docker configuration
│   ├── requirements.txt    # Python dependencies
│   ├── buildspec.yml       # AWS CodeBuild specification
│   └── appspec.yaml        # AWS CodeDeploy specification
├── modules/                # Terraform modules
│   ├── alb/                # Application Load Balancer module
│   ├── codepipeline/       # CodePipeline, CodeBuild, CodeDeploy module
│   ├── ecr/                # Elastic Container Registry module
│   ├── ecs/                # Elastic Container Service module
│   ├── iam/                # IAM roles and policies module
│   └── vpc/                # VPC, subnets, and networking module
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
└── terraform.tfvars.example # Example variable definitions
```

## Deployment Instructions

1. Clone this repository:
   ```
   git clone <repository-url>
   cd CICD_Project
   ```

2. Create a `terraform.tfvars` file based on the example:
   ```
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` with your specific values, especially:
   - `github_owner`: Your GitHub username
   - `github_repo`: Your repository name
   - `github_token`: Your GitHub personal access token

4. Initialize Terraform:
   ```
   terraform init
   ```

5. Apply the Terraform configuration:
   ```
   terraform apply
   ```

6. After successful deployment, push changes to your GitHub repository to trigger the pipeline.

## Pipeline Workflow

1. Changes pushed to the specified GitHub branch trigger the pipeline
2. CodeBuild builds a Docker image from the Dockerfile
3. The image is pushed to Amazon ECR
4. CodeDeploy performs a blue/green deployment to ECS
5. Traffic is gradually shifted to the new version

## Cleanup

To destroy all resources created by this project:

```
terraform destroy
```

## Notes

- The ALB is publicly accessible; consider adding security measures for production
- Secrets like GitHub tokens should be stored in AWS Secrets Manager for production use
- Consider adding CloudWatch alarms and monitoring for production deployments
# Terraform-CICD-Deployment
