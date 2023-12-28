#!/bin/bash

set -e

rm -r stage{0,1,2} || true
mkdir -p stage{0,1,2}

# add shadow
cp Sources/*.png stage0
cd stage0
for i in *.png; do 
  echo "adding shadow: $i"
  convert "$i" \( +clone -background black -shadow 30x1+2+2 \) +swap -background none -layers merge +repage "../stage1/$i"
done
cd ..

# create x cursors
cp Sources/*.conf stage1
cd stage1
for f in *.conf; do
  CURSORNAME="$(echo $f | sed "s/.conf//")"
  echo "creating cursor: $f -> $CURSORNAME"
  xcursorgen "$f" "../stage2/$CURSORNAME"
done

cd ..
mv stage2/* ./cursors

# create montage
montage -geometry +0+0 -tile 5x ./stage1/{arrow0,left_ptr_watch0,grab0,watch0,X_cursor0,right_side0,based_arrow_down0,bottom_left_corner0,bottom_right_corner0,center_ptr0,cross0,fleur0,question_arrow0,xterm0}.png -bordercolor white -border 10x10 montage.png


rm -r stage{0,1,2}

