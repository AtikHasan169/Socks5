#!/bin/sh
set -e

##############################################
# LOAD MULTIPLE USERS FROM ENV
##############################################

AUTH_LIST=""
i=1

while true; do
    USER_VAL=$(eval echo "\$USER_$i")
    PASS_VAL=$(eval echo "\$PASS_$i")

    if [ -z "$USER_VAL" ]; then
        break
    fi

    if [ -z "$PASS_VAL" ]; then
        echo "ERROR: PASS_$i is missing!"
        exit 1
    fi

    if [ -z "$AUTH_LIST" ]; then
        AUTH_LIST="${USER_VAL}:${PASS_VAL}"
    else
        AUTH_LIST="${AUTH_LIST}@${USER_VAL}:${PASS_VAL}"
    fi

    echo "Loaded User $i: $USER_VAL"

    i=$((i+1))
done

if [ -z "$AUTH_LIST" ]; then
    echo "ERROR: No USER_x and PASS_x environment variables found!"
    exit 1
fi


##############################################
# RAILWAY PORT (DEFAULT 8080)
##############################################

MY_PORT="${PORT:-8080}"


##############################################
# LOAD MULTIPLE UPSTREAM PROXIES
##############################################

UP_LIST=""
i=1

while true; do
    VAL=$(eval echo "\$UPSTREAM_$i")
    if [ -z "$VAL" ]; then
        break
    fi

    if [ -z "$UP_LIST" ]; then
        UP_LIST="$VAL"
    else
        UP_LIST="$UP_LIST,$VAL"
    fi

    echo "Loaded Upstream $i: $VAL"

    i=$((i+1))
done

if [ -z "$UP_LIST" ]; then
    echo "ERROR: No UPSTREAM_x variables found!"
    exit 1
fi


##############################################
# START GOST
##############################################

echo "---------------------------------------"
echo " Public SOCKS running on: 0.0.0.0:$MY_PORT"
echo " Users loaded:"
echo "$AUTH_LIST"
echo ""
echo " Upstream Proxies:"
echo "$UP_LIST"
echo "---------------------------------------"

exec gost \
    -L "socks5://${AUTH_LIST}@:${MY_PORT}" \
    -F "forward://$UP_LIST"