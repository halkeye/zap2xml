#!/bin/sh
[ "${DEBUG:-false}" = "true" ] && set -x

download() {
    MOD_TIME='0'
    RETRY_INTERVAL='30'
    while true; do
        RUN_TIME="$(date '+%s')"
        # shellcheck disable=SC2086
        /zap2xml.pl -u "$1" -p "$2" -U -o "$3" -c "$(echo "$1" | tr -d -- '-_@.+')" $OPT_ARGS
        printf 'Run time: '
        date -d "@$RUN_TIME" '+%F %T %Z'
        if [ -f "$3" ]; then
            MOD_TIME="$(date -r "$3" '+%s')"
        fi
        if test "$MOD_TIME" -lt "$RUN_TIME"; then
            echo "This run did not complete successfully, trying again in $RETRY_INTERVAL seconds..."
            sleep "$RETRY_INTERVAL"
            RETRY_INTERVAL="$(( RETRY_INTERVAL * 2 ))"
            if test "$RETRY_INTERVAL" -gt "$SLEEPTIME"; then
                RETRY_INTERVAL='30'
            fi
        else
            echo 'Run successful.'
            break
        fi
    done
}

while true; do
    if [ -z "$USERNAME2" ] || [ "$USERNAME2" = 'none' ]; then
        # shellcheck disable=SC2153
        download "$USERNAME" "$PASSWORD" "/data/$XMLTV_FILENAME"
    else
        mkdir -p /tmp/xmltv/raws
        mkdir -p /tmp/xmltv/sorted
        download "$USERNAME" "$PASSWORD" "/tmp/xmltv/raws/1.xml"
        download "$USERNAME2" "$PASSWORD2" "/tmp/xmltv/raws/2.xml"
        echo 'Sorting both files.'
        tv_sort /tmp/xmltv/raws/1.xml --by-channel --output /tmp/xmltv/sorted/1.xml
        tv_sort /tmp/xmltv/raws/2.xml --by-channel --output /tmp/xmltv/sorted/2.xml
        echo 'Merging both files.'
        tv_merge -i /tmp/xmltv/sorted/1.xml -m /tmp/xmltv/sorted/2.xml -o "/data/$XMLTV_FILENAME"
        rm -rf /tmp/xmltv
        echo 'Done.'
    fi
    if [ "$SLEEPTIME" -gt 0 ]; then
        echo "Will run again in $SLEEPTIME seconds."
        sleep "$SLEEPTIME"
    fi
done
