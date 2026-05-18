#!/bin/bash
set -euo pipefail

exec > >(tee /var/log/user-data.log) 2>&1
echo "=== Start user_data: $(date) ==="

apt-get update -y
apt-get upgrade -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  rsync

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | \
  tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | \
  tee /etc/apt/sources.list.d/cloudflared.list

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

apt-get update -y
apt-get install -y sqlite3 docker-ce docker-ce-cli containerd.io docker-compose-plugin cloudflared nodejs

corepack enable
corepack prepare pnpm@latest --activate

usermod -aG docker ubuntu

systemctl enable docker
systemctl start docker

cloudflared service install ${cloudflare_tunnel_token}

# Bedrock Configuration
# Note: Ensure model access is enabled in the AWS Console for ${aws_region}
# Model usage enabled via IAM role for Claude (Sonnet) and Minimax.
export AWS_DEFAULT_REGION=${aws_region}

# Install Hermes Workspace
# curl -fsSL https://raw.githubusercontent.com/outsourc-e/hermes-workspace/main/install.sh | bash
# source ~/.bashrc
# hermes setup 
# mkdir -p ~/.hermes && touch ~/.hermes/.env
# sed -i '/^HERMES_PASSWORD=/d ; /^AWS_REGION=/d' ~/.hermes/.env
# printf "HERMES_PASSWORD=${hermes_ui_pass}\nAWS_REGION=${aws_region}\n" >> ~/.hermes/.env
# hermes gateway run
# hermes dashboard &
# hermes doctor --fix
# cd ~/hermes-workspace && pnpm approve-builds
# cd ~/hermes-workspace && pnpm install
# cd ~/hermes-workspace && pnpm start:all &


# Fix permissions for user
# sudo chown -R $USER:$USER ~/.hermes ~/workspace
# mkdir -p ~/.hermes
# chmod -R 777 ~/.hermes

# https://www.youtube.com/watch?v=fUem4KS572c

echo "=== End user_data: $(date) ==="



