rid -GLId $1 | grep -v '^\*' > /tmp/$1.chords
grep '!!!' $1 > /tmp/$1.comments

dpd=$(pattern -f ../../patterns/dpd /tmp/$1.chords | head -1 | awk '{print $6}')
dpd1=$(pattern -f ../../patterns/dpd /tmp/$1.chords | head -1 | awk '{print $9}')
awk -v dpd=$dpd -v dpd1=$dpd1 '{ if (NR >= dpd && NR <= dpd1)
print $0,"\011""D";
else print $0
}' /tmp/$1.chords > /tmp/$1.dpd

#11-5
ptp=$(pattern -f ../../patterns/ptp /tmp/$1.chords | head -1 | awk '{print $6}')
ptp1=$(pattern -f ../../patterns/ptp /tmp/$1.chords | head -1 | awk '{print $9}')
awk -v dpd=$dpd -v dpd1=$dpd1 '{ if (NR >= ptp && NR <= ptp1)
print $0,"\011""P";
else print $0
}' /tmp/$1.dpd # > /tmp/$1.ptp

#####Grab comments as variable?

####Grab musical data as variable
####Run things on musical data
####Cat everything together.


#####Cleaner
#
# if $3 == D and $4 == D (cadential 64)
# 	print print $1,"\011"$2,"\011""D (cadential 64)"