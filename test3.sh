#!/bin/sh

sort $1 -o $2
sort -r $1 -o $2.r
rm -f $2.r
