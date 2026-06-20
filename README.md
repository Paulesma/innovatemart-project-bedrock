# Project Bedrock: InnovateMart’s Inaugural EKS Deployment

### **Metadata & Standards**
- **Company:** InnovateMart Inc.
- **Project Mission:** Production-Grade Microservices Deployment on AWS EKS
- **Student ID:** `ALT/SOE/025/3974`
- **AWS Region:** `us-east-1`
- **Target Namespace:** `retail-app`

---

## 1. Repository Architecture Layout

This repository is structured to cleanly separate cloud infrastructure orchestration from the Kubernetes application manifests and serverless pipelines:

```text
├── .github/
│   └── workflows/
│       └── terraform.yml          # GitHub Actions CI/CD Orchestration Pipeline
├── terraform/
│   ├── main.tf                    # Core VPC, EKS, RDS, DynamoDB, Lambda Infra
│   ├── variables.tf               # Input Variable definitions
│   ├── outputs.tf                 # Required Automated Grading Output matrix
│   ├── providers.tf               # Cloud Provider configurations
│   ├── iam_policy.json            # AWS Load Balancer Controller Custom Policy
│   └── terraform.tf               # Remote Backend State definitions
├── kubernetes/
│   ├── ingress.yaml               # Application Load Balancer Ingress Resource
│   ├── rbac.yaml                  # Developer View (bedrock-dev-view) Bindings
│   └── values.yaml                # Production Retail App Helm Values Overrides
├── lambda/
│   ├── index.py                   # Python Serverless Asset Event Processor 
│   └── lambda.zip                 # Built payload artifact packaged for Lambda
└── grading.json                   # Output evaluation matrix parsed by grader
```

---

## 2. CI/CD Infrastructure Pipeline Execution

The infrastructure lifecycle is entirely automated via GitHub Actions utilizing repository secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).

### **Pipeline Workflows:**
1. **Pull Request into `main`:** Automatically initializes the workspace and executes `terraform plan`. The generated execution plan is cleanly appended directly to the PR comments for review.
2. **Merge / Push to `main`:** Automatically runs `terraform apply --auto-approve` to provision or update live cloud resources securely.

---

## 3. Deployment & Setup Guide

### **Step 1: Automated Infrastructure Provisioning**
Ensure your local or remote repository contains the appropriate target keys, then merge your branch to `main`. This establishes:
- The VPC (`project-bedrock-vpc`) with private/public subnets across 2 AZs.
- The EKS Cluster (`project-bedrock-cluster`) running Kubernetes `v1.34`.
- Managed Data Layers (RDS MySQL, RDS PostgreSQL, DynamoDB) locked inside the private subnets.
- The AWS Load Balancer Controller running in the `kube-system` namespace.

### **Step 2: Deploying the Application Layer (Bonus 5.1 Included)**
Run the following initialization sequence from your CLI to mount the configuration context and install the application using Helm:

```bash
# 1. Authenticate with the newly deployed EKS cluster
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster

# 2. Add the upstream retail store repository
helm repo add retail-store-sample-app https://github.io
helm repo update

# 3. Create the targeted retail-app namespace
kubectl create namespace retail-app

# 4. Deploy the chart using our production values override pointing to the AWS data layer
helm upgrade --install retail-app retail-store-sample-app/retail-store-sample-app -f kubernetes/values.yaml -n retail-app

# 5. Apply the public Ingress and RBAC access maps
kubectl apply -f kubernetes/ingress.yaml
kubectl apply -f kubernetes/rbac.yaml
```

---

## 4. Grading Verification Manual (Instructor Reference)

### **Core Security: Developer Access Check (`bedrock-dev-view`)**
To evaluate the strict read-only RBAC requirements inside the cluster, load the developer IAM credentials provided in the submission document and execute:

```bash
# Verify view rights (Should succeed)
kubectl get pods -n retail-app

# Verify write-blocking restriction (Should fail immediately)
kubectl delete namespace retail-app
```

### **Core Serverless: S3 Event Notification Trigger**
The user `bedrock-dev-view` has been granted granular `s3:PutObject` access on the asset repository. Test the trigger pipeline via the AWS CLI using the developer credentials:

```bash
# Upload a test file to verify the notification hook
aws s3 cp sample.jpg s3://bedrock-assets-alt-soe-025-3974/

# Validation: Check CloudWatch Logs for /aws/lambda/bedrock-asset-processor. 
# Output will print exactly: "Image received: sample.jpg"
```

### **Core Observability: Centralized Logging Check**
- **Control Plane Logs:** Navigate to AWS CloudWatch Log Groups under `/aws/eks/project-bedrock-cluster/cluster` to verify that API, Audit, and Authenticator actions are streaming correctly.
- **Application Logs:** Check CloudWatch logs streamed via the Amazon CloudWatch Observability agent to verify container outputs from the `retail-app` namespace.

---

## 5. Grading Matrix Generator
To assist the automated parsing evaluation script, the dynamic infrastructure parameter json artifact was generated and committed directly to the root workspace using:
```bash
cd terraform
terraform output -json > ../grading.json
```
