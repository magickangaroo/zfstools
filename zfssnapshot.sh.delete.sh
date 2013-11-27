#!/bin/bash
for snapshot in `zfs list -H -t snapshot | cut -f 1`
do
zfs destroy $snapshot
done
