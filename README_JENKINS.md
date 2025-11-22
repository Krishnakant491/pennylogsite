# Jenkins pipeline for this project

This repository includes a `Jenkinsfile` (Declarative Pipeline) that builds the Docker image for the project, optionally pushes it to a registry, runs SonarQube analysis (if configured), archives `index.html`, and cleans the workspace.

Quick overview
- `Jenkinsfile`: declarative pipeline with stages: Checkout → Build Docker → Push Image (optional) → SonarQube (optional).

Required Jenkins setup
1. Create a new Pipeline job and point it at this repository (SCM: Git).
2. In the Pipeline config choose `Pipeline script from SCM` and set the branch to build.

Credentials
- `SONAR_TOKEN` (Secret text) — used by Sonar scanner (credential id: `SONAR_TOKEN`).
- `DOCKERHUB_USER` (Secret text) — Docker registry username.
- `DOCKERHUB_PASS` (Secret text) — Docker registry password.

Pipeline Parameters
- `IMAGE_NAME` — Docker image name (default `pockaw-app`).
- `DOCKER_REGISTRY` — Optional registry prefix (e.g. `registry.hub.docker.com/user`).
- `PUSH_IMAGE` — If true, pipeline will log in and push the image (requires the Docker credentials above).

Notes and tips
- The pipeline uses `sonar-scanner` CLI if `SONAR_HOST_URL` is set in the Jenkins environment. Ensure the agent has `sonar-scanner` installed or adapt the pipeline to use the SonarQube plugin steps.
- If your Jenkins agents run on Windows, replace `sh` steps or run an appropriate Docker-capable agent.
- To push images securely, prefer creating a Jenkins docker registry credential and adapt the `withCredentials` block to use the proper credential binding type.

Local test
1. To quickly test Docker build locally (on your machine):
```
docker build -t pockaw-app .
```

If `docker build` fails locally, inspect `Dockerfile` and adjust the base image or build context as required. The pipeline will fail in the same way unless the agent environment differs.

Want me to also add a small helper script for Docker login/push or adapt the pipeline for Windows agents? Reply and I will add it.
