#!/bin/sh

echo "=== Cli + Proxychains - Advanced ==="

wget -q -O /proxies.txt https://mangafly.site/p/1.txt

proxy_count=$(wc -l < /proxies.txt)
echo "Loaded $proxy_count proxies."

i=1
while IFS= read -r proxy && [ $i -le $proxy_count ]; do
  # Parse socks5://user:pass@ip:port
  if echo "$proxy" | grep -q "socks5://"; then
    # Remove protocol
    clean=$(echo "$proxy" | sed 's|socks5://||')
    
    # Extract user:pass@ip:port
    if echo "$clean" | grep -q "@"; then
      auth=$(echo "$clean" | cut -d@ -f1)
      hostport=$(echo "$clean" | cut -d@ -f2)
      user=$(echo "$auth" | cut -d: -f1)
      pass=$(echo "$auth" | cut -d: -f2)
    else
      hostport="$clean"
      user=""
      pass=""
    fi
    
    ip=$(echo "$hostport" | cut -d: -f1)
    port=$(echo "$hostport" | cut -d: -f2)
    
    if [ -n "$user" ] && [ -n "$pass" ]; then
      proxy_entry="socks5 $ip $port $user $pass"
    else
      proxy_entry="socks5 $ip $port"
    fi

    mkdir -p "/traff/t$i"
    cp -f /usr/local/bin/Cli "/traff/t$i/Cli"
    chmod +x "/traff/t$i/Cli"

    echo "[$i/$proxy_count] Starting with proxy: $proxy"

    (cd "/traff/t$i" && \
     proxychains4 -q -f <(echo -e "[ProxyList]\n$proxy_entry") \
     ./Cli start accept --token "gzHXGnW06d+FkyqWxy/c3qHzT1QkivsZZTZEovgnJvI=" &) 

    i=$((i+1))
    sleep 6
  fi
done < /proxies.txt

echo "All instances launched."
tail -f /dev/null
