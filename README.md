# 🚀 Strapi v4 on AWS ECS Fargate

This project demonstrates how to containerize a **Strapi v4** application and deploy it to **AWS ECS Fargate** using a fully automated **GitHub Actions** CI/CD pipeline.

## 📌 Project Overview

* **Framework:** Strapi v4 (Headless CMS)
* **Runtime:** Node.js v18 (LTS)
* **Infrastructure:** AWS ECS Fargate (Serverless Containers)
* **CI/CD:** GitHub Actions
* **Containerization:** Docker

---

## 🛠️ Local Development Setup

To run this project in your local environment or GitHub Codespaces:

1. **Switch to Node 18:**
```bash
nvm install 18
nvm use 18

```


2. **Install Dependencies:**
```bash
npm install

```


3. **Build the Admin UI:**
```bash
npm run build

```


4. **Start the Project:**
```bash
npm run develop

```



---

## 🐳 Dockerization

The project includes a multi-stage `Dockerfile` optimized for production:

* Uses `node:18-alpine` for a small image size.
* Installs necessary build tools (`vips-dev`, `build-base`) for sharp/better-sqlite3.
* Automatically builds the Strapi Admin UI during the image creation.

**Build Docker image locally:**

```bash
docker build -t strapi-ecs-fargate .

```

---

## 🚢 Deployment Pipeline (CI/CD)

The GitHub Actions workflow (`.github/workflows/deploy.yml`) performs the following:

1. **Lint & Test:** Ensures code quality.
2. **Docker Build:** Builds the production-ready image.
3. **Push to ECR:** Authenticates with AWS and pushes the image to **Amazon Elastic Container Registry**.
4. **ECS Update:** Triggers a new deployment on **AWS ECS Fargate**, replacing old tasks with the new image.

---

## 📁 Repository Structure

```text
├── .github/workflows/   # CI/CD pipeline definitions
├── config/              # Strapi configuration files
├── src/                 # Main application logic (API, Admin)
├── Dockerfile           # Production container definition
├── .dockerignore        # Files to exclude from Docker build
├── package.json         # Project dependencies and scripts
└── terraform/           # Infrastructure as Code (Optional)

```
