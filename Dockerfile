FROM debian:latest

# ユーザー作成
RUN useradd -m -s /bin/bash user
WORKDIR /home/user

# apt 更新
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y ssh tmux vim git curl apt-file iproute2

# TODO
# - ローカルネットワークとの通信は全て遮断
# - クレデンシャルを保持しない
# - GitHub 等には ssh-agent 経由で接続

USER user
