Finance App
This is a sample finance application that consists of a front-end web app and a backend API. The app is deployed on AWS using Kubernetes and Jenkins.

Architecture Overview
The application consists of the following components:

Front-end web app: A simple HTML/CSS/JS application that displays a list of financial transactions. The application allows users to filter transactions based on category and date.
Backend API: A RESTful API that serves financial transaction data. The API is built using Node.js and MongoDB.
Kubernetes Cluster: The Kubernetes cluster is hosted on AWS using Amazon Elastic Kubernetes Service (EKS). The cluster consists of two worker nodes and a single master node.
Jenkins Server: The Jenkins server is used to manage the CI/CD pipeline for the application. The server is hosted on AWS using an EC2 instance.
File Structure
The project directory is structured as follows:

.
├── app
│   ├── index.html
│   ├── main.js
│   ├── style.css
│   └── ...
├── infra
│   ├── eks
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── ...
│   ├── jenkins
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── ...
│   ├── provider.tf
│   └── ...
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
├── Jenkinsfile
├── Dockerfile
├── README.md
└── ...

Getting Started
Prerequisites
AWS account
Docker
kubectl
Terraform
Node.js
MongoDB
Deployment Steps
Clone the repository: git clone https://github.com/example/finance-app.git.
Set up the MongoDB database.
Build the Docker image: docker build -t finance-app .
Push the Docker image to a container registry.
Deploy the Kubernetes resources: kubectl apply -f k8s/
Set up Jenkins on an EC2 instance.
Set up the Jenkins pipeline using the Jenkinsfile.
Access the finance app at http://<load-balancer-address>/.
For more detailed instructions, please refer to the individual files in the project directory.

Author:
Henry Chekwi - For HBC Trainings (HTech Solution)