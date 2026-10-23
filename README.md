# swarm_robot_sim

TurtleBot3 + Gazebo + Nav2 によるマルチロボットシミュレーション環境。
生産管理システムから、複数台のロボットへの作業指示と結果の受け取りを検証するための基盤。

## 動作確認環境

| 項目 | 内容 |
|---|---|
| 実行環境 | Docker (ROS 2 Jazzy / Ubuntu 24.04) |
| シミュレータ | Gazebo (modern) |
| ホスト | Linux(研究室PC)。SSH + X転送で接続 |

## 使い方

### 1. 接続(GUI表示のため `-Y` を付ける)

```bash
ssh -Y <user>@<host>
```

### 2. イメージのビルド(初回のみ)

```bash
git clone https://github.com/dev-ryu-lea/swarm_robot_sim.git
cd swarm_robot_sim
./scripts/build.sh
```

### 3. コンテナの起動

```bash
./docker/run.sh
```

### 4. 動作確認

コンテナ内で、上から順に確認する。

```bash
xeyes                      # X転送の確認
glxgears                   # GL描画の確認
ros2 launch nav2_bringup tb3_simulation_launch.py
```

RVizが開いたら、2D Pose Estimateで初期位置を指定し、Nav2 Goalでゴールを与える。
Gazebo本体のGUIはX転送だと重いので、必要なときだけ `headless:=False` を付ける。

### 5. 自作パッケージのビルド(コンテナ内)

```bash
cd /ws
colcon build
source install/setup.bash
```

## ディレクトリ構成

```
docker/    Dockerfile, run.sh
scripts/   ビルドなどの補助スクリプト
src/       自作ROS 2パッケージ
docs/      設計メモ
```

## 共用PCでの注意

- ROS 2の通信は `ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST` とドメインID(既定 42)で
  他のユーザーと分離している。衝突する場合は `ROS_DOMAIN_ID=<別の値> ./docker/run.sh` とする。
- Gazeboの通信は `GZ_PARTITION` でユーザーごとに分離している。
