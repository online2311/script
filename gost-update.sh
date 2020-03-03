#!/bin/bash
# Usage:
#   curl https://raw.githubusercontent.com/online2311/script/master/gost-update.sh | bash

METHOD="-C /etc/gost.json"

VER="$(wget -qO- https://github.com/ginuerzh/gost/tags | grep -oE "/tag/v.*" | sed -n '1p' | sed 's/\".*//;s/^.*v//')"
VER=${VER:=2.11.0}
URL="https://github.com/ginuerzh/gost/releases/download/v${VER}/gost-linux-amd64-${VER}.gz"

echo "Downloading gost_${VER} to /usr/bin/gost from $URL"
rm -rf /usr/bin/gost-linux-amd64*
wget -O /usr/bin/gost-linux-amd64-${VER}.gz $URL
gzip -d /usr/bin/gost-linux-amd64-${VER}.gz && 
cd /usr/bin/ && systemctl stop gost.service && rm -rf /usr/bin/gost && mv gost-linux-amd64-${VER} /usr/bin/gost && chmod +x /usr/bin/gost  && systemctl start gost.service && systemctl status gost -l
