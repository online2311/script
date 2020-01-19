#!/bin/bash
# Usage:
#   curl https://raw.githubusercontent.com/online2311/script/master/gost.sh | bash

METHOD="-C /etc/gost.json"

VER="$(wget -qO- https://github.com/ginuerzh/gost/tags | grep -oE "/tag/v.*" | sed -n '1p' | sed 's/\".*//;s/^.*v//')"
VER=${VER:=2.9.1}
URL="https://github.com/ginuerzh/gost/releases/download/v${VER}/gost-linux-amd64-${VER}.gz"

echo "Downloading gost_${VER} to /usr/bin/gost from $URL"
rm -rf /usr/bin/gost
wget -O /usr/bin/gost-linux-amd64-${VER}.gz $URL
gzip -d /usr/bin/gost-linux-amd64-${VER}.gz && cd /usr/bin/ && mv gost-linux-amd64-${VER} /usr/bin/gost && cd
chmod +x /usr/bin/gost

echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
Description=gost
[Service]
ExecStart=/usr/bin/gost $METHOD
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

echo "Generate /etc/gost.json"
cat <<EOF > /etc//gost.json
{
    "Retries": 1,
    "Debug": false,
    "ServeNodes": [
        "socks5+mws://nodecloud:123456@:80"
    ]
}
EOF

systemctl enable gost.service && systemctl daemon-reload && systemctl restart gost.service && systemctl status gost -l
