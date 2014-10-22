grep '!!!' $1 > /tmp/$1.comments
rid	-GLId	$1
grep	'!!!'	$1
####Enfore	Dominant	prolongation
dpd=$(pattern	-f	../../patterns/dpd
dpd1=$(pattern	-f	../../patterns/dpd
awk	-v	dpd=$dpd
print	$1,"\011"$2"\011""D";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.chords	>
######Enforce	prolongation	of
ptp=$(pattern	-f	../../patterns/ptp
ptp1=$(pattern	-f	../../patterns/ptp
awk	-v	ptp=$ptp
print	$1,"\011"$2"\011""P";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.dpd	>
####Enforce	Tonic	prolongations,
tdt=$(pattern	-f	../../patterns/tdt
tdt1=$(pattern	-f	../../patterns/tdt
awk	-v	tdt=$tdt
print	$1,"\011"$2"\011""T";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.ptp	>
####Enforce	P	prolongation
pdp=$(pattern	-f	../../patterns/pdp
pdp1=$(pattern	-f	../../patterns/pdp
awk	-v	pdp=$pdp
print	$1,"\011"$2"\011""P";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.tdt	>
####Enforce	D	prolongation
dtd=$(pattern	-f	../../patterns/dtd
dtd1=$(pattern	-f	../../patterns/dtd
awk	-v	dtd=$dtd
print	$1,"\011"$2"\011""D";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.pdp	>
####Enforce	T	prolongation
tpt=$(pattern	-f	../../patterns/tpt
tpt1=$(pattern	-f	../../patterns/tpt
awk	-v	tpt=$tpt
print	$1,"\011"$2"\011""T";	
else	print	$1"\011"$2"\011"$3
}'	/tmp/$1.dtd	>
cat	/tmp/$1.comments	/tmp/$1.tpt
#####Grab	comments	as
####Grab	musical	data
####Run	things	on
####Cat	everything	together.
#####Cleaner		
#		
#	if	$3==
#	print	print
