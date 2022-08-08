#!/bin/bash

for i in 0 1 2 3
do
   ffmpeg -hide_banner -loglevel error -y -framerate 8 -i "$i/%04d.jpg" -c:v libx264 -pix_fmt yuv420p $i.mp4;
done

printf "file '%s'\n" *.mp4 >> clips; 
ffmpeg -hide_banner -loglevel error -f concat -i clips -c copy $1.mp4;
rm clips;
printf "Done.\n";

