#!/bin/bash 
#Anpassung für big endian unter RHEL 7 
WDIR=~ 
while true; do 
stty -F /dev/ttyUSB0 9600 raw 
INPUT=$(dd conv=swab bs=10 count=1 </dev/ttyUSB0 2>/dev/null | od -x -N10 |head -n 1|cut -f2-10 -d" "); 
#Ausgabe 
#echo $INPUT 
#echo " " 
FIRST4BYTES=$(echo $INPUT|cut -b1-4); 

#echo $FIRST4BYTES 
if [ "$FIRST4BYTES" = "aac0" ]; then 

#  echo "check for correct intro characters: ok" 
echo " $INPUT " 
else 
  echo "incorrect sequence, exiting" 
  exit; 
fi
PPM25LOW=$(echo $INPUT|cut -f2 -d " "|cut -b1-2);  
PPM25HIGH=$(echo $INPUT|cut -f2 -d " "|cut -b3-4); 
PPM10LOW=$(echo $INPUT|cut -f3 -d " "|cut -b1-2);  
PPM10HIGH=$(echo $INPUT|cut -f3 -d " "|cut -b3-4); 

#zu Dezimal konvertieren 
PPM25LOWDEC=$( echo $((0x$PPM25LOW)) ); 
PPM25HIGHDEC=$( echo $((0x$PPM25HIGH)) ); 
PPM10LOWDEC=$( echo $((0x$PPM10LOW)) ); 
PPM10HIGHDEC=$( echo $((0x$PPM10HIGH)) ); 

PPM25=$(echo "scale=1;((( $PPM25HIGHDEC * 256 ) + $PPM25LOWDEC ) / 10 )"|bc -l ); 
PPM10=$(echo "scale=1;((( $PPM10HIGHDEC * 256 ) + $PPM10LOWDEC ) / 10 )"|bc -l ); 
echo "Feinstaub PPM25: $PPM25" 
echo "Feinstaub PPM10: $PPM10"
done