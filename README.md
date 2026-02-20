# Strapi Infrastructure with AWS CloudWatch Monitoring (Task 7)

This project automates the deployment of a Strapi application on **AWS ECS Fargate** using **Terraform**. It focuses on observability by implementing centralized logging and performance monitoring.

## 🚀 Key Features (Task 7 Requirements)

* **Infrastructure as Code (IaC):** Complete AWS environment (VPC, ECR, ECS) managed via Terraform.
* **Centralized Logging:** Integrated **AWS CloudWatch Logs** with a dedicated log group `/ecs/strapi`.
* **Container Insights:** Enabled CloudWatch Container Insights on the ECS cluster for deep performance metrics (CPU, Memory, Network).
* **Custom Monitoring Dashboard:** A CloudWatch Dashboard to visualize the health and resource utilization of the Strapi service.
* **CI/CD Integration:** Automated deployment pipeline via GitHub Actions.

## 🛠 Tech Stack

* **Cloud Provider:** AWS (ECS Fargate, ECR, VPC, CloudWatch)
* **Provisioning:** Terraform
* **Application:** Strapi (Node.js Headless CMS)

## 📝 Current Deployment Status & Technical Notes

> **Note on IAM Permissions:**
> During the final deployment, the project encountered an `AccessDenied` error while creating new IAM roles (`iam:CreateRole`) due to restricted permissions in the internship sandbox environment.
> **Resolution:** > * The Terraform code was updated to use the existing `ecsTaskExecutionRole`.
> * The infrastructure (VPC, Log Groups, Cluster, and ECR) is **100% successfully deployed**.
> * The Task 7 monitoring configuration (Container Insights & Log Drivers) is fully implemented in the `main.tf` logic.
> 
> 

## 📂 Project Structure

```text
.
├── .github/workflows/  # CI/CD Pipeline scripts
├── main.tf             # Core Terraform Infrastructure
└── README.md           # Documentation

```

## 📈 Monitoring & Observability

To view the results of Task 7:

1. Navigate to **CloudWatch > Log groups** to see the `/ecs/strapi` streams.
2. Navigate to **CloudWatch > Dashboards** to view the "Strapi-Monitoring-Dashboard".


