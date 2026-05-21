# urbanpetr.com

Personal website at [urbanpetr.com](https://urbanpetr.com) and admin panel at [admin.urbanpetr.com](https://admin.urbanpetr.com) — built with Nuxt 3, deployed on AWS via Terraform and GitHub Actions.

## Repository layout

```
/                  — public website (Nuxt 3, static)
/admin             — admin SPA (Nuxt 3, static, auth-gated)
/terraform/envs/prod   — infrastructure for the public website
/terraform/envs/admin  — infrastructure for the admin panel
```

## Stack

- **Frontend** — [Nuxt 3](https://nuxt.com) (Vue 3), Tailwind CSS, PrimeVue
- **Infrastructure** — AWS S3 + CloudFront (OAC) + shared WAF, managed with Terraform
- **Auth** — AWS Cognito (OAuth2 PKCE, Google identity provider)
- **CI/CD** — GitHub Actions (deploy on merge to `main`; ephemeral PR envs via `stage` label)

---

## Website

### Local development

```bash
npm install
npm run dev        # dev server at http://localhost:3000
npm run generate   # static site generation
npm run preview    # preview static build locally
```

### Environment variables

| Variable | Required | Description |
|---|---|---|
| `NUXT_PUBLIC_API_BASE` | yes | API base URL, e.g. `https://api.urbanpetr.com` |

---

## Admin

The admin panel is a separate Nuxt app in `/admin`. It is auth-gated via AWS Cognito (Google sign-in, PKCE flow). All pages redirect to `/login` unless a valid access token is present in `sessionStorage`.

### Local development

```bash
cd admin
npm install
npm run dev        # dev server at http://localhost:3000
npm run generate   # static site generation
npm run preview    # preview static build locally
```

### Environment variables

| Variable | Required | Description |
|---|---|---|
| `NUXT_PUBLIC_API_BASE` | yes | API base URL |
| `NUXT_PUBLIC_COGNITO_DOMAIN` | yes | Cognito domain, e.g. `urbanpetr-prod.auth.eu-central-1.amazoncognito.com` |
| `NUXT_PUBLIC_COGNITO_CLIENT_ID` | yes | Cognito app client ID |

### Auth flow

1. Unauthenticated users are redirected to `/login` by a global Nuxt route middleware.
2. Clicking "Sign in" triggers the PKCE OAuth2 flow: a verifier/challenge pair is generated in the browser, stored in `sessionStorage`, and the user is redirected to the Cognito hosted UI.
3. Cognito redirects back to `/callback?code=…`. A critical inline `<head>` script (injected before all framework JS) saves `location.search` to `sessionStorage['__qs__']` — this is required because Nuxt's router plugin strips the query string during prerendered-page hydration before any component setup code runs.
4. The callback page reads `__qs__` from `sessionStorage`, exchanges the code + verifier for tokens at the Cognito token endpoint, and stores the access token in `sessionStorage`.
5. The access token is sent as a `Bearer` token on all API requests.

### Infrastructure

The admin CloudFront distribution uses a **CloudFront Function** (viewer-request) to rewrite `/path` → `/path/index.html`. This is required because CloudFront + S3 OAC serves exact S3 key matches only — without it, `/callback` would 403 and SPA fallback would serve the root `index.html`, sending the OAuth code to the wrong page.

---

## Deployments

### Production

Merging a PR into `main` triggers a GitHub Actions workflow that:

1. Runs `terraform apply` for both the website and admin infra
2. Runs `nuxt generate` for both apps
3. Syncs static files to their respective S3 buckets
4. Invalidates the CloudFront cache

The production CloudFront distribution is protected by a shared WAF WebACL (IP reputation list, common rule set, 1000 req/5 min per-IP rate limit). The WAF is provisioned by the `urbanpetr-api` Terraform state and referenced here via `terraform_remote_state`.

### Staging (per-PR ephemeral environments)

Add the `stage` label to a PR to spin up ephemeral environments at:

```
https://stage{pr_number}.urbanpetr.com        — public website
https://admin-stage{pr_number}.urbanpetr.com  — admin panel
```

The workflow also registers the staging callback URL with the **staging** Cognito user pool client (in a separate AWS account) so OAuth login works per-PR.

The environments are destroyed automatically when the label is removed or the PR is closed. The staging Cognito callback URL is deregistered on destroy.

> **Note:** Both prod and staging infra deployments use the `AWS_ROLE_TO_ASSUME_PROD` secret (Account A). Route53, ACM, and CloudFront all live in Account A — the cross-account complexity isn't justified for a static site. Cognito staging uses `AWS_ROLE_TO_ASSUME_COGNITO_STAGING` (Account B).

### Required GitHub secrets

| Secret | Used by |
|---|---|
| `AWS_ROLE_TO_ASSUME_PROD` | All infra and deploy jobs |
| `AWS_ROLE_TO_ASSUME_COGNITO_STAGING` | Cognito callback registration in staging |
| `COGNITO_DOMAIN` | Admin prod build |
| `COGNITO_CLIENT_ID` | Admin prod build |
| `COGNITO_DOMAIN_STAGING` | Admin staging build |
| `COGNITO_CLIENT_ID_STAGING` | Admin staging build |
| `COGNITO_USER_POOL_ID_STAGING` | Cognito callback registration in staging |
| `GLOBAL_MODULES_PAT` | Terraform private module access (GitHub) |
| `GA_MEASUREMENT_ID` | Website analytics |
