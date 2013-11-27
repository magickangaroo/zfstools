#!/bin/bash                                                                                                      

DAYS=60

for POOL in storage; do
    echo $POOL
    cd /$POOL
    for i in *; do
        snapcheck=`zfs list | awk {'print $1'} | egrep "$POOL/$i@$DAYS$"`
        if [ "$snapcheck" != "" ]; then
            echo " old snapshot found, destroy it"
            zfs destroy $POOL/$i@$DAYS
        fi

        let STARTDAY=$DAYS-1
        for ((s=$STARTDAY; s >= 1; s--)); do
            snapcheck=`zfs list | awk {'print $1'} | egrep "$POOL/$i@$s$"`
            if [ "$snapcheck" != "" ]; then
                echo "snapshot exists, rollover"
                let NEXTSNAP=$s+1
                zfs rename $POOL/$i@$s @$NEXTSNAP
            fi
        done;
        zfs snapshot $POOL/$i@1
    done;
done;
