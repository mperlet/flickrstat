#!/bin/bash

# Requires: curl, jq, xargs, sed, bc, convert and t

# Flickr + Twitter User
FUSER='mperlet'
TUSER='@mperlet_'

# User Info URL
DATA=$(curl http://flickrit.pboehm.org/photos/$FUSER)

# Temp
TFAV=$(cat stat.tmp | head -n1)
TCOM=$(cat stat.tmp | head -n2 | tail -n1)
TVIE=$(cat stat.tmp | head -n3 | tail -n1)
TCOU=$(cat stat.tmp |  tail -n1)

# Data sum
FAV=$(echo $DATA | jq ".[] .count_faves" | xargs | sed -e 's/\ /+/g' | bc)
COM=$(echo $DATA | jq ".[] .count_comments" | xargs | sed -e 's/\ /+/g' | bc)
VIE=$(echo $DATA | jq ".[] .views" | xargs | sed -e 's/\ /+/g' | bc)
COU=$(echo $DATA | jq ".[] .count_faves" | wc -l)

# Diff
DFAV=$(($FAV-$TFAV))
DCOM=$(($COM-$TCOM))
DVIE=$(($VIE-$TVIE))
DCOU=$(($COU-$TCOU))

# echo "Diffs: " $DFAV $DCOM $DVIE

DMSG=""
if [ $DFAV -ne "0" ]; then
   DMSG="$DFAV Favs"
fi

if [ $DCOM -ne "0" ]; then
   DMSG="$DMSG $DCOM Comments"
fi

if [ $DVIE -ne "0" ]; then
   DMSG="$DMSG $DVIE Views"
fi



# Write Temp
echo $FAV > stat.tmp
echo $COM >> stat.tmp
echo $VIE >> stat.tmp
echo $COU >> stat.tmp

# Data sum
FAV=$(echo "Favorites...."  $FAV)
COM=$(echo "Comments....."  $COM)
VIE=$(echo "Views........"  $VIE)
COU=$(echo "sum(Images).."  $COU)

# Add Image
convert -size 3500x840 xc:whitesmoke -font Courier-Bold -pointsize 140 -fill black -draw "text 5,140 'Flickr stats for : $(echo $FUSER)'" -draw "text 5,380 '$(echo $VIE)'" -draw "text 5,520 '$(echo $FAV)'" -draw "text 5,660 '$(echo $COM)'" -draw "text 5,800 '$(echo $COU)'"  $FUSER.png

# Twitter if something new
if [ -n "$DMSG" ]; then
   t update -f $FUSER.png "Hey, $TUSER $DMSG"
fi

# Delete File
rm $FUSER.png
