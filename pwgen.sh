#!/usr/bin/env bash

FILE=users.txt

for user in $(cat $FILE)
do
	PASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c15)
	echo $user "$PASS"
done
