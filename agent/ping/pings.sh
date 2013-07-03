#!/bin/sh

cd /home/soren/src/netmon
./hostPing.rb 8.8.8.8 google-dns &
./hostPing.rb mirror.ac.za &
./hostPing.rb ec2.ap-southeast-2.amazonaws.com ec2-syd &

