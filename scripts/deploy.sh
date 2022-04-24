#!/bin/bash

PROJECT_ID=domo-334121
CLOUD_REGION=northamerica-northeast1
GAR_REGISTRY=${CLOUD_REGION}-docker.pkg.dev
GAR_REPO=${GAR_REGISTRY}/${PROJECT_ID}/domo
RUN_SERVICE_NAME=domo-run

# Required by ko
export KO_DOCKER_REPO=northamerica-northeast2-docker.pkg.dev/domo-334121/domo


# Authenticate
# gcloud init --skip-diagnostics --project domo-334121
gcloud auth configure-docker ${GCP_REGION} --project ${PROJECT_ID} --verbosity error

# Build and deploy container to artifact registry
image_ref=$(ko publish ./cmd/bot/)
gcloud run deploy ${RUN_SERVICE_NAME} \
  --image=${image_ref} \
  --region ${CLOUD_REGION} \
  --set-secrets=/config/bot_config=bot_config:latest,DISCORD_TOKEN=discord_token:latest \
  --args=-c,/config/bot_config
