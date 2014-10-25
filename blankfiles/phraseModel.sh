rid -GLId $1 | grep -v '^\*' > /tmp/$1.chords
grep '!!!' $1 > /tmp/$1.comments
grep '^\*.[a-z]' $1 > /tmp/$1.metaData
grep '^\*M' $1 > /tmp/$1.metre

awk '{if ($1 !~ /[0-9]/) print $1"\011"$1"\011"$1; else print $0}' /tmp/$1.chords > /tmp/$1.chords1

####Enfore Dominant prolongation over D-P-D
dpd=$(pattern -f ../patterns/dpd /tmp/$1.chords1 | head -1 | awk '{print $6}')
dpd1=$(pattern -f ../patterns/dpd /tmp/$1.chords1 | head -1 | awk '{print $9}')
awk -v dpd=$dpd -v dpd1=$dpd1 '{ if (NR >= dpd && NR <= dpd1)
print $1,"\011"$2"\011""D";
else print $1"\011"$2"\011"$3
}' /tmp/$1.chords > /tmp/$1.dpd

######Enforce prolongation of P and rid movements to T.
ptp=$(pattern -f ../patterns/ptp /tmp/$1.dpd | head -1 | awk '{print $6}')
ptp1=$(pattern -f ../patterns/ptp /tmp/$1.dpd | head -1 | awk '{print $9}')
awk -v ptp=$ptp -v ptp1=$ptp1 '{ if (NR >= ptp && NR <= ptp1)
print $1,"\011"$2"\011""P";
else print $1"\011"$2"\011"$3
}' /tmp/$1.dpd > /tmp/$1.ptp

####Enforce Tonic prolongations, and smooth odd dominants.
tdtp=$(pattern -f ../patterns/tdtp /tmp/$1.ptp | head -1 | awk '{print $6}')
tdtp1=$(pattern -f ../patterns/tdtp /tmp/$1.ptp | head -1 | awk '{print $9}')
awk -v tdtp=$tdtp -v tdtp1=$tdtp1 '{ if (NR >= tdtp && NR <= tdtp1)
print $1,"\011"$2"\011""T";
else print $1"\011"$2"\011"$3
}' /tmp/$1.ptp > /tmp/$1.tdtp

tdt=$(pattern -f ../patterns/tdt /tmp/$1.tdtp | head -1 | awk '{print $6}')
tdt1=$(pattern -f ../patterns/tdt /tmp/$1.tdtp | head -1 | awk '{print $9}')
awk -v tdt=$tdt -v tdt1=$tdt1 '{ if (NR >= tdt && NR <= tdt1)
print $1,"\011"$2"\011""T";
else print $1"\011"$2"\011"$3
}' /tmp/$1.tdtp > /tmp/$1.tdt

tdt2=$(pattern -f ../patterns/tdt2 /tmp/$1.tdt | head -1 | awk '{print $6}')
tdt3=$(pattern -f ../patterns/tdt2 /tmp/$1.tdt | head -1 | awk '{print $9}')
awk -v tdt2=$tdt2 -v tdt3=$tdt3 '{ if (NR >= tdt2 && NR <= tdt3)
print $1,"\011"$2"\011""T";
else print $1"\011"$2"\011"$3
}' /tmp/$1.tdt > /tmp/$1.tdt2

####Enforce P prolongation over PDP
pdp=$(pattern -f ../patterns/pdp /tmp/$1.tdt2 | head -1 | awk '{print $6}')
pdp1=$(pattern -f ../patterns/pdp /tmp/$1.tdt2 | head -1 | awk '{print $9}')
awk -v pdp=$pdp -v pdp1=$pdp1 '{ if (NR >= pdp && NR <= pdp1)
print $1,"\011"$2"\011""P";
else print $1"\011"$2"\011"$3
}' /tmp/$1.tdt2 > /tmp/$1.pdp

####Enforce D prolongation over DTD
dtd=$(pattern -f ../patterns/dtd /tmp/$1.pdp | head -1 | awk '{print $6}')
dtd1=$(pattern -f ../patterns/dtd /tmp/$1.pdp | head -1 | awk '{print $9}')
awk -v dtd=$dtd -v dtd1=$dtd1 '{ if (NR >= dtd && NR <= dtd1)
print $1,"\011"$2"\011""D";
else print $1"\011"$2"\011"$3
}' /tmp/$1.pdp > /tmp/$1.dtd

####Little Dominants are people too.
lildom=$(pattern -f ../patterns/lildom /tmp/$1.dtd | head -1 | awk '{print $6}')
lildom1=$(pattern -f ../patterns/lildom /tmp/$1.dtd | head -1 | awk '{print $9}')
awk -v lildom=$lildom -v lildom1=$lildom1 '{ if (NR >= lildom && NR <= lildom1)
print $1,"\011"$2"\011""T";
else print $1"\011"$2"\011"$3
}' /tmp/$1.dtd > /tmp/$1.dtd1

####Enforce T prolongation over TPT
tpt=$(pattern -f ../patterns/tpt /tmp/$1.dtd1 | head -1 | awk '{print $6}')
tpt1=$(pattern -f ../patterns/tpt /tmp/$1.dtd1 | head -1 | awk '{print $9}')
awk -v tpt=$tpt -v tpt1=$tpt1 '{ if (NR >= tpt && NR <= tpt1)
print $1,"\011"$2"\011""T";
else print $1"\011"$2"\011"$3
}' /tmp/$1.dtd1 > /tmp/$1.tpt

##clean up files that have blanks
awk '{if ($3 ~ /^[ ]*$/) { print $1,"\011"$2"\011""T" } 
else if ($1 ~ /=/) print $1"\011"$1"\011"$1; else print $0}' /tmp/$1.tpt > /tmp/$1.tpt2

awk '{if ($1 !~ /[0-9]/) print $1"\011"$1"\011"$1; else print $0}' /tmp/$1.tpt2 > /tmp/$1.tpt3

cat /tmp/$1.comments /tmp/$1.metaData /tmp/$1.metre /tmp/$1.tpt3

#####Grab comments as variable?

####Grab musical data as variable
####Run things on musical data
####Cat everything together.


#####Cleaner
#
# if $3 == D and $4 == D (cadential 64)
# 	print print $1,"\011"$2,"\011""D (cadential 64)"