#!/bin/bash
tags=$(kdialog -inputbox "Tags: " "tags" )

cmd="tmsu tag --tags=\"$tags\""

for file in "${@}"
do
    cmd="$cmd \"$file\""
done

bash -c "$cmd"
