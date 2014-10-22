######OPENING	SUBSTITUTIONS##########	
awk	'BEGIN{FS=","}{if	($1
else	if	($1
else	if	($1
else	if	T
else	if	($1
else	if	($1
else	print	$0}'
############I	Chords	##################
####	Rule	1:
opening_tonic1=$(pattern	-f	../patterns/openingTonic
opening_tonic2=$(pattern	-f	../patterns/openingTonic
awk	-v	opening_tonic=$opening_tonic1
else	if	(NR
print	$0,"\011""T"	T
else	print	$0}'
T		
#	####	Rule
closing_tonic_start=$(pattern	-f	../patterns/closingTonic
closing_tonic_end=$(pattern	-f	../patterns/closingTonic
awk	-v	clsSt=$closing_tonic_start
print	$0,"\011""T";	T
else	print	$0
}'	/tmp/$1.tonicOpening	|
sed	's/\*-	/\*-
#	T	
#	#	####Rule
first_line=$(pattern	-f	../patterns/cad64
second_line=$(pattern	-f	../patterns/cad64
awk	-v	first=$first_line
else	if(NR==	first)
print	$0,"\011""D	(cadential
else	if	(NR==
print	$0,"\011""D	(cadential
else	print	$0}'
#	T	
#	###	Diminished
awk	'{	if
print	$1,"\011"$2,"\011""D	(vii
else	print	$0
T		
T		
awk	'{	if
print	$1,"\011"$2,"\011""D	(vii
else	print	$0
T		
####Enforce	phrase	model
#	pseudo	code:
#	if	D
#	if	D
#	if	D
#	if	ends
T		
T		
T		
T		
#	#	T
texpand1=$(pattern	-f	../patterns/tonicDominantExpansion
texpand2=$(pattern	-f	../patterns/tonicDominantExpansion
awk	-v	texpand1=$texpand1
print	$1,"\011"$2,"\011""T	(Tonic
else	T	
print	$0}'	/tmp/$1.dominantsubs_vii
T		
####Tonic	Expansion	through
texpand_vii_1=$(pattern	-f	D
texpand_vii_2=$(pattern	-f	D
awk	-v	texpand_vii_1=$texpand1
print	$1,"\011"$2,"\011""T	(Tonic
else	T	
print	$0}'	/tmp/$1.tonicExpansion
T		
###Root	Position	Tonics####
awk	'{if	($1
else	print	$0}'
T		
#####Smoothing	to	get
T		
smooth1=$(pattern	-f	../patterns/smoothing
smooth2=$(pattern	-f	../patterns/smoothing
awk	-v	smooth1=$smooth1
print	$1,"\011"$2,"\011""T	(Tonic
else	if	(NR==
print	$1,"\011"$2,"\011""T	(Tonic
else	T	
print	$0}'	/tmp/$1.smoothing
T		
smooth3=$(pattern	-f	../patterns/smoothing2
smooth4=$(pattern	-f	../patterns/smoothing2
awk	-v	smooth3=$smooth3
else	if	(NR
else	if	(NR
else	print	$0
}'	/tmp/$1.smoothing1	>
T		
domdom1=$(pattern	-f	../patterns/domdom
domdom2=$(pattern	-f	../patterns/domdom
awk	-v	domdom1=$domdom1
print	$1,"\011"$2,"\011""D"	T
else	print	$0
}'	/tmp/$1.smoothing2	>
T		
domdom3=$(pattern	-f	../patterns/domdom2
domdom4=$(pattern	-f	../patterns/domdom2
awk	-v	domdom3=$domdom3
print	$1,"\011"$2,"\011""D"	T
else	print	$0
}'	/tmp/$1.smoothing3	>
T		
domdom5=$(pattern	-f	../patterns/domdom3
domdom6=$(pattern	-f	../patterns/domdom3
awk	-v	domdom5=$domdom5
print	$1,"\011"$2,"\011""D"	T
else	print	$0
}'	/tmp/$1.smoothing4	>
T		
T		
##################ii	and	P
####label	ii	and
awk	'{	if
print	$1,"\011"$2,"\011""P"	T
else	if	($1
else	if	($1
else	print	$0
#######Arpeggiating	as	expanding
arpP1=$(pattern	-f	../patterns/arpPD
arpP2=$(pattern	-f	P
T 	P	T
awk 	-v	T
print 	$1,"\011"$2,"\011""T"	T
else	T	
print	$0	T
}'	/tmp/$1.sd1	>
T		
#####IV6	as	P
T		
arpP1a=$(pattern	-f	P
arpP2a=$(pattern	-f	P
awk	-v	P
print	$1,"\011"$2,"\011""D"	T
else	T	
print	$0	T
}'	/tmp/$1.sd2	>
T		
######Plagal	Motion	(IV)
arpP1b=$(pattern	-f	../patterns/arpPDb
arpP2b=$(pattern	-f	../patterns/arpPDb
awk	-v	arpP1b=$arpP1b
print	$1,"\011"$2,"\011""T"	T
else	T	
print	$0	T
}'	/tmp/$1.sd3	>
######Plagal	Motion	(ii65)
arpP1c=$(pattern	-f	../patterns/arpPDc
arpP2c=$(pattern	-f	../patterns/arpPDc
awk	-v	arpP1c=$arpP1c
print	$1,"\011"$2,"\011""D"	T
else	T	
print	$0	T
}'	/tmp/$1.sd4	>
T		
##########iii	chords	T
##########iii	chords	P
###Make	all	iii
awk	'{	if
print	$1,"\011"$2,"\011""T"	T
else	if	($1
print	$1,"\011"$2,"\011""P"	T
print	$0	T
}'	/tmp/$1.sd5	>
T		
##	V	and
#	Rule	1
awk	'{	if
print	$1,"\011"$2,"\011""D"	T
else	T	
print	$0	T
}'	/tmp/$1.iii	>
T		
##Rule	2	(V6
#	I	chords
domTonicExpansion_1=$(pattern	-f	../patterns/domexpansion_1
domTonicExpansion_2=$(pattern	-f	../patterns/domexpansion_1
domTonicExpansion_3=$(pattern	-f	../patterns/domexpansion_2
domTonicExpansion_4=$(pattern	-f	../patterns/domexpansion_2
awk	-v	domTonicExpansion_1=$domTonicExpansion_1
print	$1,"\011"$2,"\011""T"	T
else	if	(NR
print	$1,"\011"$2,"\011""T"	T
else	T	
print	$0	}'
T		
#	#####If	V
awk	'{	if
print	$1,"\011"$2,"\011""T"	T
else	if	($1
print	$0	T
else	print	$0
}'	/tmp/$1.d2	>
#	T	
#	####Passing	6/4
passingV64_1=$(pattern	-f	../patterns/passingV64
passingV64_2=$(pattern	-f	../patterns/passingV64
awk	-v	passingV64_1=$passingV64_1
{	if	(NR
print	$1,"\011"$2,"\011""T"	T
else	T	
print	$0	T
}'	/tmp/$1.d3	>
T		
#	#######V-vii	Rules
#	T	
#	T	
awk	'{if	($1
print	$1,"\011"$2,"\011""T"	T
else	if	T
print	$1,"\011"$2,"\011""T"	T
else	if	($1
print	$1,"\011"$2,"\011""D"	T
else	print	$0
}'	/tmp/$1.d4	>
#	#	T
#	T	
deceptive_1=$(pattern	-f	P
awk	-v	deceptive_1=$deceptive_1
print	$1,"\011"$2,"\011""T"	T
else	print	$0
T		
T		
T		
sed	's/	/
awk	'{if($1	~
else	if	($1
#	#	T
#	T	
