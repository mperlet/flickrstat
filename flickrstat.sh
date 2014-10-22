#!/bin/bash

# Requires: curl, jq, xargs, sed, bc, convert and t

# Flickr + Twitter User
FUSER='mperlet'
TUSER='@mperlet_'

# User Info URL
DATA=$(curl http://flickrit.pboehm.org/photos/$FUSER)

# Data sum
FAV=$(echo "Favorites...."  $(echo $DATA | jq ".[] .count_faves" | xargs | sed -e 's/\ /+/g' | bc))
COM=$(echo "Comments....."  $(echo $DATA | jq ".[] .count_comments" | xargs | sed -e 's/\ /+/g' | bc))
VIE=$(echo "Views........"  $(echo $DATA | jq ".[] .views" | xargs | sed -e 's/\ /+/g' | bc))
COU=$(echo "sum(Images).."  $(echo $DATA | jq ".[] .count_faves" | wc -l))

# Add Image
convert -size 350x84 xc:whitesmoke -font Courier-Bold -pointsize 14 -fill black -draw "text 5,14 'Flickr stats for : $(echo $FUSER)'" -draw "text 5,38 '$(echo $VIE)'" -draw "text 5,52 '$(echo $FAV)'" -draw "text 5,66 '$(echo $COM)'" -draw "text 5,80 '$(echo $COU)'"  $FUSER.png

# Twitter stuff
t update -f $FUSER.png "Hey, $TUSER new stats!"

# Delete File
rm $FUSER.png
