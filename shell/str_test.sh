#!/bin/bash

## strA contains strB
# meth1
strA="helloworld"
strB="low"
if [[ $strA =~ $strB ]]; then
  echo "包含"
else
  echo "不包含"
fi
