# ROS 2 Jazzy (Ubuntu 24.04) + Gazebo (modern) + Nav2 + TurtleBot3
FROM osrf/ros:jazzy-desktop

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup \
    ros-jazzy-nav2-minimal-tb* \
    ros-jazzy-ros-gz \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    xauth x11-apps mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# SSH経由のX転送ではGPUが使えないのでソフトウェア描画に固定
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV QT_X11_NO_MITSHM=1

WORKDIR /ws
