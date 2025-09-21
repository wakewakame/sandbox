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
		iproute2

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

CMD ["/usr/sbin/sshd", "-D"]
