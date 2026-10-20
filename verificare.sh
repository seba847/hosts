
#!/bin/bash

cat /etc/hosts | while read ip nume rest
do
    # Ignoram liniile goale si comentariile
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    for host in $nume $rest
    do
        if [[ "$host" == \#* ]]; then
            break
        fi

        rezultat=$(nslookup "$host" 2>/dev/null | awk '/^Address: / {print $2}' | tail -n 1)

        if ! echo "$rezultat" | grep -Fxq "$ip"; then
            echo "Bogus IP for $host in /etc/hosts!"
        fi
    done
done

