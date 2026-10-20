
#!/bin/bash

# Functie pentru verificarea unei adrese IP
verifica_ip() {
    local host="$1"
    local ip="$2"
    local dns="$3"

    rezultat=$(nslookup "$host" "$dns" 2>/dev/null |
        awk '/^Name:/{gasit=1; next} gasit && /^Address: /{print $2}')

    if ! echo "$rezultat" | grep -Fxq "$ip"; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
}

# Serverul DNS utilizat
DNS="8.8.8.8"

# Citirea fisierului /etc/hosts
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

        verifica_ip "$host" "$ip" "$DNS"
    done
done

