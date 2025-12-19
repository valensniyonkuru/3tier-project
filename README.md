# 3-Tier AWS Architecture with Terraform

This project deploys a highly available, scalable, and secure 3-tier architecture on AWS using Terraform. The infrastructure is modularized and follows best practices for infrastructure-as-code (IaC).

## Architecture Overview

The architecture consists of three layers (tiers) spread across two Availability Zones for high availability:

1.  **Presentation Layer (Public Tier)**:

    - **Public Subnets**: Host the Application Load Balancer (ALB) and NAT Gateway.
    - **Application Load Balancer (ALB)**: Distributes incoming HTTP traffic to the application tier.
    - **Internet Gateway**: Allows public access to the ALB.

2.  **Application Layer (Private Tier)**:

    - **Private App Subnets**: Host the EC2 instances.
    - **Auto Scaling Group (ASG)**: Manages EC2 instances running an Apache Web Server. It ensures scalability and fault tolerance by replacing unhealthy instances.
    - **NAT Gateway**: Allows private instances to access the internet for updates (outbound only) without being exposed to incoming public traffic.

3.  **Data Layer (Private Tier)**:
    - **Private DB Subnets**: Host the RDS database.
    - **RDS Instance**: A managed relational database (MySQL) accessible only from the Application Layer.

### Architecture Diagram

```ascii
                         ┌─────────────────────────────┐
                         │     Application Load        │
                         │        Balancer (ALB)       │
                         └──────────────┬──────────────┘
                                        │
               ┌────────────────────────────────────────────────┐
               │                                                │
        Public Subnet A                                  Public Subnet B
               │                                                │
               ▼                                                ▼
        ┌─────────────┐                                  ┌─────────────┐
        │  Web/App    │                                  │  Web/App    │
        │   EC2/ASG   │                                  │   EC2/ASG   │
        └─────────────┘                                  └─────────────┘
               ▼                                                ▼
        ┌────────────────────────────────────────────────────────────────┐
        │                        RDS MySQL DB                            │
        │                      (Private DB Subnets)                      │
        └────────────────────────────────────────────────────────────────┘
```

## Modules Description

The repository is structured into reusable modules:

- **`modules/networking`**:
  - Creates the VPC, Public/Private subnets, Internet Gateway, NAT Gateway, and Route Tables.
  - Output: VPC ID, Subnet IDs.
- **`modules/security`**:
  - Creates Security Groups with strict chaining rules.
  - `alb_sg`: Allows HTTP/HTTPS from 0.0.0.0/0.
  - `app_sg`: Allows traffic only from `alb_sg`.
  - `db_sg`: Allows traffic only from `app_sg`.
- **`modules/alb`**:
  - Provisions the Application Load Balancer, Listener, and Target Group.
- **`modules/compute`**:
  - Configures the Launch Template (Amazon Linux 2, Apache) and Auto Scaling Group.
- **`modules/database`**:
  - Provisions the RDS MySQL instance and DB Subnet Group.

## Deployment Instructions

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed (v1.0+).
- AWS CLI installed and configured (`aws configure`).

### Steps

1.  **Clone the repository**:

    ```sh
    git clone https://github.com/valensniyonkuru/3tier-project.git
    cd 3tier-project
    ```

2.  **Initialize Terraform**:
    Download provider plugins and initialize modules.

    ```sh
    terraform init
    ```

3.  **Review the Plan**:
    See what resources will be created.

    ```sh
    terraform plan
    ```

4.  **Deploy**:
    Provision the infrastructure.

    ```sh
    terraform apply
    ```

    Type `yes` when prompted.

5.  **Access the Application**:
    After successful deployment, Terraform will output the `alb_dns`. Copy and paste it into your browser.

    ```
    http://<alb_dns_output>
    ```

    You should see: `"Hello from Terraform 3-Tier App"`

6.  **Clean Up**:
    To destroy all resources:
    ```sh
    terraform destroy
    ```

## Variables and Outputs

### Inputs (Variables)

Key variables that can be customized in `variables.tf` or passed via CLI:

| Variable        | Description        | Default        |
| --------------- | ------------------ | -------------- |
| `region`        | AWS Region         | `eu-central-1` |
| `vpc_cidr`      | CIDR block for VPC | `10.0.0.0/16`  |
| `instance_type` | EC2 Instance Type  | `t3.micro`     |
| `db_name`       | Database Name      | `threetierdb`  |

### Outputs

After applying, Terraform will display:

| Output         | Description                                         |
| -------------- | --------------------------------------------------- |
| `alb_dns`      | The DNS name of the Load Balancer (Application URL) |
| `rds_endpoint` | The endpoint URL for the RDS database               |
| `asg_name`     | The name of the Auto Scaling Group                  |
| `vpc_id`       | The ID of the created VPC                           |


###  Screenshots
- ALB
<img width="959" height="421" alt="image" src="https://github.com/user-attachments/assets/5e7da732-8265-4883-83aa-d03a4aaddaba" />

- RDS
<img width="959" height="419" alt="image" src="https://github.com/user-attachments/assets/0f6abb9f-3119-4322-8999-fae0d832c043" />
- EC2/ASG
<img width="1918" height="727" alt="image" src="https://github.com/user-attachments/assets/9b9d9080-073d-43d9-9407-b247b85530e1" />
- VPC
<img width="1918" height="706" alt="image" src="https://github.com/user-attachments/assets/9cedd03c-9a5d-44e2-a643-760f2d55cfa5" />

<img width="1918" height="724" alt="image" src="https://github.com/user-attachments/assets/a0fe2bfe-81ce-469c-85f9-edd438a0ec49" />

