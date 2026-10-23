#!/usr/bin/env bash
# コンテナを起動する。リポジトリ直下を /ws にマウントするので、
# コンテナ内の /ws/src が src/、colcon buildの成果物は build/ install/ log/ に出る。
#
# 使い方: ./docker/run.sh            # 対話シェル
#         ./docker/run.sh <コマンド>  # コマンドを直接実行
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="swarm_robot_sim:jazzy-${USER}"
NAME="swarm_robot_sim_${USER}"

# 共用PC対策: 他の人のROS 2/Gazeboと通信が混ざらないようにする
ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-42}"

if [ -z "${DISPLAY:-}" ]; then
  echo "DISPLAY が未設定です。ssh -Y で接続し直してください。" >&2
  exit 1
fi

# X転送用の認証ファイルを一時作成(終了時に削除)
XAUTH="$(mktemp /tmp/.docker.xauth.XXXXXX)"
trap 'rm -f "$XAUTH"' EXIT
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
chmod 600 "$XAUTH"

if [ "$#" -eq 0 ]; then
  CMD=(bash -c 'source /ws/install/setup.bash 2>/dev/null; exec bash')
else
  CMD=("$@")
fi

docker run -it --rm \
  --name "$NAME" \
  --net=host \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp/home \
  -e DISPLAY="$DISPLAY" \
  -e XAUTHORITY=/tmp/.xauth \
  -e ROS_DOMAIN_ID="$ROS_DOMAIN_ID" \
  -e ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST \
  -e GZ_PARTITION="$NAME" \
  -v "$XAUTH":/tmp/.xauth:ro \
  -v "$REPO_DIR":/ws \
  "$IMAGE" \
  "${CMD[@]}"
