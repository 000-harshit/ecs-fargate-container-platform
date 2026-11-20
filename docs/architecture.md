# Architecture walkthrough

## Request path

1. A user reaches the internet-facing Application Load Balancer.
2. The ALB forwards HTTP traffic to the frontend ECS service.
3. The frontend calls the backend using the Service Connect discovery name `backend` on port `5001`.
4. The backend is private and has no public ALB listener or public IP.

## Network layout

- Two public subnets host the ALB across two Availability Zones.
- Two private subnets host the ECS tasks.
- The ALB security group is the only source allowed to reach the frontend application port.
- The frontend security group is the only source allowed to reach the backend application port.
- Interface endpoints provide private connectivity to ECR API, ECR Docker, and CloudWatch Logs.
- An S3 gateway endpoint supports private access to S3.
- VPC Flow Logs send accepted/rejected flow metadata to CloudWatch Logs.

## Why no NAT Gateway?

The design uses VPC endpoints for the AWS services required by task image pulls and log delivery. This avoids a NAT Gateway in this reference architecture. It does **not** mean the design has zero networking cost: interface endpoints are billed while provisioned. The application containers should not depend on arbitrary public internet access.

## Local equivalent

Docker Compose creates a private bridge network for the frontend and backend. The frontend reaches the backend by its service name, `backend`. This is a local demonstration of the same discovery pattern; it is not an AWS ECS Service Connect test.
