# urbanpetr.com

Personal website at [urbanpetr.com](https://urbanpetr.com) — built with Nuxt 3, deployed on AWS via Terraform and GitHub Actions.

## Stack

- **Frontend** — [Nuxt 3](https://nuxt.com) (Vue 3), Tailwind CSS, PrimeVue
- **Infrastructure** — AWS S3 + CloudFront, managed with Terraform
- **CI/CD** — GitHub Actions (deploy on merge to `main`)

## Local Development

```bash
npm install
npm run dev       # starts dev server at http://localhost:3000
npm run build     # production build
npm run generate  # static site generation
npm run preview   # preview production build locally
```

## Prerequisites

To deploy infrastructure you'll need:

- AWS account with CLI configured
- An IAM user/role that allows Terraform to run via GitHub (e.g. `terraform-github`)
- A DynamoDB table for Terraform state locking
- An S3 bucket for Terraform remote state

## Deployments

### Production env

Merging a PR into `main` triggers a GitHub Actions workflow that

- builds the site
- syncs it to S3
- invalidates the CloudFront cache

### Staging (per-PR / ephemeral env)

Add the `stage` label to any PR to spin up a ephemeral / temporary staging environment at:

```
https://stage{pr_number}.urbanpetr.com
# e.g. https://stage42.urbanpetr.com
```

The environment is destroyed automatically when the label is removed or the PR is closed.

> **Note:** Unlike `urbanpetr-api`, staging environments for this repo are deployed to **Account A (prod account)**, not the staging account. This is intentional — Route53, ACM, and CloudFront all live in Account A, and the cross-account complexity isn't justified for a static site. Both prod and staging use the `AWS_ROLE_TO_ASSUME_PROD` secret.
