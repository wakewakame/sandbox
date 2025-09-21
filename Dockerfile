FROM debian:latest

# apt 更新
RUN apt update -y && \
	apt upgrade -y && \
	apt install -y \
		sudo \
		openssh-server \
		ssh \
		tmux \
		vim \
		git \
		curl \
		apt-file \
		iproute2 \
		nodejs \
		npm \
		locales \
		locales-all \
		manpages-ja \
		manpages-ja-dev

# 日本語が入力できるよう設定
RUN locale-gen && update-locale LANG=ja_JP.UTF-8

# node.js の最新版インストール
RUN npm install -g n
RUN n stable

# ユーザー作成
RUN useradd -m -s /bin/bash user && \
    passwd -d user

# sshd 設定
RUN mkdir /var/run/sshd
RUN <<EOF
cat << _DOC_ > /etc/ssh/sshd_config
KbdInteractiveAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
PermitRootLogin no
AllowUsers user
PermitEmptyPasswords yes
_DOC_
EOF
RUN rm -f /etc/ssh/ssh_host_*_key*
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# dotfiles の設定
USER user
WORKDIR /home/user
RUN git clone https://github.com/wakewakame/dotfiles.git
WORKDIR /home/user/dotfiles
RUN ./install-dotfiles.sh
USER root

CMD ["/usr/sbin/sshd", "-D"]
