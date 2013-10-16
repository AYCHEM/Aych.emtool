#!/bin/bash
PATH=.:$PATH
killall python
cd
cd mailpile
git pull
exec mp
