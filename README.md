# homelab-app-template

Template for apps that run on the homelab k3s cluster.

- Push to `dev` → image built → deployed to **staging** (`<app>-staging.murarvagen.se`)
- Push to `main` → image built → deployed to **prod** (`<app>.murarvagen.se`)

This repo only **builds**. It pushes a multi-arch image (arm64 + amd64) to GHCR and asks the `homelab` repo to deploy it. Deploy config, the runner and cluster access all live in `homelab`.

## Creating a new app

1. **New repo from this template:** click *Use this template*, choose the organization as owner, and create the repo. The repo name becomes the app name, so use lowercase with dashes, e.g. `wiki`.
2. **Share the org deploy secret with it** (only if the secret is limited to selected repos): Organization → Settings → Secrets and variables → Actions → `HOMELAB_DEPLOY_APP_KEY` → add the repo. Do the same for the variable `HOMELAB_DEPLOY_APP_ID`.
3. **Register the app in homelab:** copy `homelab-config/` to `homelab/apps/<app-name>/`, fill in the placeholders, and push to `main` in homelab. Nothing is deployed yet at that point; it just makes the app known.
4. **Replace the example** `Dockerfile` and `index.html` with your app. The app must listen on `containerPort` (8080 by default) and answer `probePath` with HTTP 200.
5. **Create a `dev` branch and push.** Staging is up within a few minutes. Merge to `main` for prod.

You can delete `homelab-config/` from the app repo afterwards.

How the deploy GitHub App and the org secret are set up once is described in the `homelab` README.

## Optional variables

| Variable | Set at | Default | Use when |
|---|---|---|---|
| `HOMELAB_REPO_NAME` | org | `homelab` | the deploy repo has another name |
| `HOMELAB_APP` | **this repo only** | this repo's name | the app should have a different name in homelab |

Never set `HOMELAB_APP` at org level, or every repo would deploy as the same app.

## Where to see what happened

- The build runs in this repo's Actions tab, and its summary links to the deploy.
- The deploy runs in the homelab repo's Actions tab. If the new version doesn't become healthy, Helm rolls back automatically and the run fails.
- The deployed version is recorded in `homelab/apps/<app>/tag-staging.yaml` and `tag-prod.yaml`.
