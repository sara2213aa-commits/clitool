#!/bin/sh

echo "=== Cli Advanced with Proxychains ==="

wget -q -O /proxies.txt https://mangafly.site/p/1.txt

proxy_count=$(wc -l < /proxies.txt)
echo "Starting $proxy_count instances..."

i=1
while IFS= read -r proxy && [ $i -le $proxy_count ]; do
  protocol=$(echo "$proxy" | grep -oE '^(socks5|http)')
  ip_port=$(echo "$proxy" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+')
  
  if [ -z "$protocol" ] || [ -z "$ip_port" ]; then
    i=$((i+1))
    continue
  fi

  mkdir -p "/traff/t$i"
  
  # کپی مطمئن‌تر
  cp -f /usr/local/bin/Cli "/traff/t$i/Cli" 2>/dev/null || echo "Copy failed for t$i"
  chmod +x "/traff/t$i/Cli"

  echo "[$i/$proxy_count] Launching with proxy..."

  proxychains4 -q -f <(echo -e "[ProxyList]\n$proxy") \
    /traff/t$i/Cli start accept --token "gzHXGnW06d+FkyqWxy/c3qHzT1QkivsZZTZEovgnJvI=" &

  i=$((i+1))
  sleep 5
done < /proxies.txt

echo "All instances started."
tail -f /dev/null
