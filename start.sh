#!/bin/sh
# start.sh

wget -q -O proxies.txt https://mangafly.site/p/1.txt

proxy_count=$(wc -l < proxies.txt)
i=1

while IFS= read -r proxy && [ $i -le $proxy_count ]; do
  protocol=$(echo "$proxy" | grep -oE '^(socks5|http)')
  auth=$(echo "$proxy" | sed -n 's#.*://\([^@]*\)@.*#\1#p')
  user=$(echo "$auth" | cut -d: -f1)
  pass=$(echo "$auth" | cut -d: -f2)
  ip_port=$(echo "$proxy" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+')
  ip=$(echo "$ip_port" | cut -d: -f1)
  port=$(echo "$ip_port" | cut -d: -f2)

  if [ -z "$protocol" ] || [ -z "$ip_port" ]; then
    i=$((i+1))
    continue
  fi

  if [ -n "$user" ] && [ -n "$pass" ]; then
    proxy_entry="$protocol $ip $port $user $pass"
  else
    proxy_entry="$protocol $ip $port"
  fi

  mkdir -p "/traff/t$i"
  cp /usr/local/bin/Cli "/traff/t$i/"

  echo "Running instance $i with proxy: $proxy_entry"
  (cd "/traff/t$i" && proxychains4 -f <(echo -e "[ProxyList]\n$proxy_entry") ./Cli start accept --token "gzHXGnW06d+FkyqWxy/c3qHzT1QkivsZZTZEovgnJvI=" &)

  i=$((i+1))
  sleep 2
done < proxies.txt

echo "All instances started. Monitoring..."
tail -f /dev/null
