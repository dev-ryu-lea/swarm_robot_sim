#!/usr/bin/env bash
# Dockerイメージをビルドする
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
docker build -t "swarm_robot_sim:jazzy-${USER}" -f "$REPO_DIR/docker/Dockerfile" "$REPO_DIR"
