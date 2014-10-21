rid -GLId $1 | grep -v '^\*' > /tmp/$1.chords
grep '!!!' $1 > /tmp/$1.comments

###DPD
dpd=$(pattern -f ../../patterns/dpd /tmp/$1.chords | head -1 | awk '{print $6}')
dpd1=$(pattern -f ../../patterns/dpd /tmp/$1.chords | head -1 | awk '{print $9}')
awk -v dpd=$dpd -v dpd1=$dpd1 '{ if (NR>=dpd && NR<=dpd1)
print $1,"\011"$2"\011""D"
else print $0
}' /tmp/$1.chords > /tmp/$1.dpd

####PTP
ptp=$(pattern -f ../../patterns/ptp /tmp/$1.dpd | head -1 | awk '{print $6}')
ptp1=$(pattern -f ../../patterns/ptp /tmp/$1.dpd | head -1 | awk '{print $9}')
awk -v ptp=$ptp -v ptp1=$ptp1 '{ if (NR >= ptp && NR <= ptp1) print $1,"\011"$2"\011""P"; else print $0}' /tmp/$1.dpd > /tmp/$1.ptp

####D-P-T Fixed
dpt=$(pattern -f ../../patterns/dpt /tmp/$1.ptp | head -1 | awk '{print $6}')
dpt1=$(pattern -f ../../patterns/dpt /tmp/$1.ptp | head -1 | awk '{print $9}')
awk -v dpt=$dpt -v dpt1=$dpt1 '{ if (NR>=dpt && NR<=dpt1) print $1,"\011"$2"\011""D"; else print $0}' /tmp/$1.ptp > /tmp/$1.ptp1


cat /tmp/$1.comments /tmp/$1.ptp1
