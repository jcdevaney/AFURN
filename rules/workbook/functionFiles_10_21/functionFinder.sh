######OPENING SUBSTITUTIONS##########

awk 'BEGIN{FS=","}{if ($1 ~ /^[0-9\.]V/) print $1"\011"$2"\011""D"; 
else if ($1 ~ /[0-9\.]V/) print $1"\011"$2"\011""D"; 
else if ($1 ~ /IV/) print $1"\011"$2"\011""P";	P
else 	if 	T
else if ($1 ~ /I[abc]/) print $1"\011"$2"\011""T";
else if ($1 ~ /^[0-9\.][iI]"\011"/) print $1"\011"$2"\011""T";
else print $0}' $1  > /tmp/$1.subbedOpening


############I Chords ################## 	T
####  Rule 1:  Label opening I chords as Tonic 	T
opening_tonic1=$(pattern -f ../patterns/openingTonic /tmp/$1.subbedOpening | head -1 | awk '{print $6}') 	T
opening_tonic2=$(pattern -f ../patterns/openingTonic /tmp/$1.subbedOpening | tail -1 | awk '{print $9}') 	T
awk -v opening_tonic=$opening_tonic1 -v opening_tonic2=$opening_tonic2 '{ if (!NF) print $0 	T
else if (NR > opening_tonic1 && NR==	 opening_tonic2)  	T
print $0,"\011""T" 	T
else print $0}' /tmp/$1.subbedOpening  > /tmp/$1.tonicOpening 	T
 	T
# #### Rule 2: Label closing I chords as tonic (beginning with first appearance of final tonicchord) 	T
closing_tonic_start=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $6}') 	T
closing_tonic_end=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $9}') 	T
awk -v clsSt=$closing_tonic_start -v clsE=$closing_tonic_end '{ if (NR >= clsSt) 	T
print $0,"\011""T"; 	T
else print $0 	T
}'  /tmp/$1.tonicOpening  | awk '{if ($3 ~ /==	/) $(NF--)=""; print}' | sed 's/==	/==	/g' | awk '{if ($3 ~ /\*-	/) $(NF--)=""; print}' | 	T
 sed 's/\*-	/\*-	/g' | sed 's/=/=/g' | sed 's/ \*-	/\*-	/g' > /tmp/$1.tonicClosing 	T
# 	T
# # ####Rule 3: Cadential 6/4 chords. 	T
first_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $6}') 	T
second_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $9}') 	T
awk -v first=$first_line -v second=$second_line '{ if (!NF) print $0 	T
else if(NR==	first) 	T
print $0,"\011""D (cadential 64)" 	T
else if (NR==	second) 
	print $0,"\011""D (cadential 64)" 	T
else print $0}' /tmp/$1.tonicClosing > /tmp/$1.cad64 	T
# 	T
# ### Diminished  as Dominant (first fule of V chord section) 	T
awk '{ if ($1 ~ /^.*viio/)TT
 print $1,"\011"$2,"\011""D (vii as dom.)" 	T
else print $0 }' /tmp/$1.cad64 > /tmp/$1.dominantsubs 	T
 	T
 	T
awk '{ if ($1 ~ /^.*viio42/)TT
 print $1,"\011"$2,"\011""D (vii as dom.)" 	T
else print $0 }' /tmp/$1.dominantsubs > /tmp/$1.dominantsubs_viiTT
	T
####Enforce phrase model here. 	T
# pseudo code: 	T
# if T is followed by end of example, V before it should be D, ii or IV before it should be P; 	T
# 	if D is followed by end, ii or IV should be labeled P, T before that should be T 	T
# 	if T is followed by end, D before that should be T, and T leading to that should be T 	T
# 		if ends with D, I before that should be tonic. 	T
 	T
 	T
 	T
 	T
# 	# 	T (Tonic on Higher Level in Phrase Model)
texpand1=$(pattern -f ../patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $6}')TT
texpand2=$(pattern -f ../patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $9}')TT
awk -v texpand1=$texpand1 -v texpand2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2) 	T
	print $1,"\011"$2,"\011""T (Tonic Expansion through Dominant)" 	T
else 	T
	print $0}' /tmp/$1.dominantsubs_vii > /tmp/$1.tonicExpansionTT
 	T
####Tonic Expansion through vii.TT
texpand_vii_1=$(pattern 	-f 	D
texpand_vii_2=$(pattern 	-f 	D
awk -v texpand_vii_1=$texpand1 -v texpand_vii_2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2)TT
	print $1,"\011"$2,"\011""T (Tonic Expansion through vii)" 	T
else 	T
	print $0}' /tmp/$1.tonicExpansion > /tmp/$1.tonicExpansion_viiTT
 	T
###Root Position Tonics#### 	T
awk '{if ($1 ~ /[0-9]\.[iI]/ && $3==	 "") print $1"\011"$2"\011""T"; else if ($1 ~ /[0-9][iI]/ && $3==	 "") print $1"\011"$2"\011""T"; 	T
 else print $0}' /tmp/$1.tonicExpansion_vii > /tmp/$1.smoothingTT
	  	T
#####Smoothing to get rid of multiple dominants in a phrase.	T
 	T
smooth1=$(pattern -f ../patterns/smoothing /tmp/$1.smoothing | head -1 | awk '{print $6}') 	T
smooth2=$(pattern -f ../patterns/smoothing /tmp/$1.smoothing | awk '{print $6}' | uniq | head -2 | tail -1) 	T
awk -v smooth1=$smooth1 -v smooth2=$smooth2 '{ if (NR==	smooth1) 	T
	print $1,"\011"$2,"\011""T (Tonic on Higher Level in Phrase Model)" 	T
else if (NR==	smooth2) 
	print $1,"\011"$2,"\011""T (Tonic on Higher Level in Phrase Model)" 	T
else 	T
	print $0}' /tmp/$1.smoothing > /tmp/$1.smoothing1	T
 	T
smooth3=$(pattern -f ../patterns/smoothing2 /tmp/$1.smoothing1 | head -1 | awk '{print $6}') 	T
smooth4=$(pattern -f ../patterns/smoothing2 /tmp/$1.smoothing1 | head -1 | awk '{print $9}') 	T
awk -v smooth3=$smooth3 -v smooth4=$smooth4 '{ if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /I/)) print $1,"\011"$2,"\011""T" 	T
else if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /IV/)) print $1	"\011"$2	P 	T
else if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /V/)) print $1,"\011"$2,"\011""D" 	T
else print $0 	T
}' /tmp/$1.smoothing1 > /tmp/$1.smoothing2 	T
 	T
domdom1=$(pattern -f ../patterns/domdom /tmp/$1.smoothing2 | head -1 | awk '{print $6}') 	T
domdom2=$(pattern -f ../patterns/domdom /tmp/$1.smoothing2 | head -1 | awk '{print $9}') 	T
awk -v domdom1=$domdom1 -v domdom2=$domdom2 '{ if (NR >= domdom1 && NR <= domdom2 && ($1 ~ /V/)) 	T
print $1,"\011"$2,"\011""D" 	T
else print $0 	T
}' /tmp/$1.smoothing2 > /tmp/$1.smoothing3 	T
 	T
domdom3=$(pattern -f ../patterns/domdom2 /tmp/$1.smoothing3 | head -1 | awk '{print $6}') 	T
domdom4=$(pattern -f ../patterns/domdom2 /tmp/$1.smoothing3 | head -1 | awk '{print $9}') 	T
awk -v domdom3=$domdom3 -v domdom4=$domdom4 '{ if (NR >= domdom3 && NR <= domdom4) 	T
print $1,"\011"$2,"\011""D" 	T
else print $0 	T
}' /tmp/$1.smoothing3 > /tmp/$1.smoothing4 	T
 	T
domdom5=$(pattern -f ../patterns/domdom3 /tmp/$1.smoothing4 | head -1 | awk '{print $6}') 	T
domdom6=$(pattern -f ../patterns/domdom3 /tmp/$1.smoothing4 | head -1 | awk '{print $9}') 	T
awk -v domdom5=$domdom5 -v domdom5=$domdom6 '{ if (NR >= domdom5 && NR <= domdom6 && ($3 ~ /D/)) 	T
print $1,"\011"$2,"\011""D" 	T
else print $0 	T
}' /tmp/$1.smoothing4 > /tmp/$1.sd 	T
 	T
 	T
##################ii 	and 	P
####label ii and IV chords as as P.	P 	T
awk '{ if ($1 ~ /^.*ii/) 	T
 print $1,"\011"$2,"\011""P" 	T
else if ($1 ~ /^.*IV/) print $1	"\011"$2	P 	T
	else if ($1 ~ /^.*iv/) print $1,"\011"$2,"\011""P"; 	T
	else print $0 }' /tmp/$1.sd > /tmp/$1.sd1  	T
#######Arpeggiating as expanding tonic (rule 3)########		T
arpP1=$(pattern -f ../patterns/arpPD /tmp/$1.sd1 | head -1 | awk '{print $6}') 	T
arpP2=$(pattern -f ../patterns/arpPD /tmp/$1.sd1 | head -1 | awk '{print $9}') 	T
 	T
awk -v arpP1=$arpP1 -v arpP2=$arpP2 '{ if (NR >= arpP1 && NR <= arpP2) 	T
print $1,"\011"$2,"\011""T" 	T
else  	T
	print $0 	T
}' /tmp/$1.sd1 > /tmp/$1.sd2 	T
 	T
#####IV6 	as 	P
 	T
arpP1a=$(pattern -f ../patterns/arpPDa /tmp/$1.sd2 | head -1 | awk '{print $6}') 	T
arpP2a=$(pattern -f ../patterns/arpPDa /tmp/$1.sd2 | head -1 | awk '{print $9}') 	T
awk -v arpP1a=$arpP1a -v arpP2a=$arpP2a '{ if (NR >= arpP1a && NR <= arpP2a) 	T
print $1,"\011"$2,"\011""D" 	T
else  	T
	print $0 	T
}' /tmp/$1.sd2 > /tmp/$1.sd3 	T
 	T
######Plagal Motion (IV)	P 	T
arpP1b=$(pattern -f ../patterns/arpPDb /tmp/$1.sd3 | head -1 | awk '{print $6}') 	T
arpP2b=$(pattern -f ../patterns/arpPDb /tmp/$1.sd3 | head -1 | awk '{print $9}') 	T
awk -v arpP1b=$arpP1b -v arpP2b=$arpP2b '{ if (NR >= arpP1b && NR <= arpP2b) 	T
print $1,"\011"$2,"\011""T" 	T
else  	T
	print $0 	T
}' /tmp/$1.sd3 > /tmp/$1.sd4 	T
######Plagal Motion (ii65) 	T
arpP1c=$(pattern -f ../patterns/arpPDc /tmp/$1.sd4 | head -1 | awk '{print $6}') 	T
arpP2c=$(pattern -f ../patterns/arpPDc /tmp/$1.sd4 | head -1 | awk '{print $9}') 	T
awk -v arpP1c=$arpP1c -v arpP2c=$arpP2c '{ if (NR >= arpP1c && NR <= arpP2c) 	T
print $1,"\011"$2,"\011""D" 	T
else  	T
	print $0 	T
}' /tmp/$1.sd4 > /tmp/$1.sd5 	T
 	T
##########iii 	chords 	T
##########iii 	chords 	P
###Make all iii chords into Tonic function and all bIII into P (rules 1 and 2) 	T
awk '{ if ($1 ~ /iii/) 	T
print $1,"\011"$2,"\011""T" 	T
else if ($1 ~ /bIII/) 	T
	print $1,"\011"$2,"\011""P" 	T
	print $0 	T
}' /tmp/$1.sd5 > /tmp/$1.iii 	T
 	T
## V and vii chords.TT
# Rule 1 (vii chords are dominant)TT
awk '{ if ($1 ~ /vii/)TT
print $1,"\011"$2,"\011""D" 	T
else  	T
	print $0 	T
}' /tmp/$1.iii > /tmp/$1.d1 	T
 	T
##Rule 2 (V6 and viio6 chords can expand tonic function when acting as a neighbor between two root position TT
# I chords or as passing between I and I6) 	T
domTonicExpansion_1=$(pattern -f ../patterns/domexpansion_1 /tmp/$1.d1 | head -1 | awk '{print $6}') 	T
domTonicExpansion_2=$(pattern -f ../patterns/domexpansion_1 /tmp/$1.d1 | head -1 | awk '{print $9}') 	T
domTonicExpansion_3=$(pattern -f ../patterns/domexpansion_2 /tmp/$1.d1 | head -1 | awk '{print $6}') 	T
domTonicExpansion_4=$(pattern -f ../patterns/domexpansion_2 /tmp/$1.d1 | head -1 | awk '{print $9}') 	T
awk -v domTonicExpansion_1=$domTonicExpansion_1 -v domTonicExpansion_2=$domTonicExpansion_2  -v domTonicExpansion_3=$domTonicExpansion_3 -v domTonicExpansion_4=$domTonicExpansion_4 '{ if (NR >= domTonicExpansion_1 && NR <= domTonicExpansion_2) 	T
print $1,"\011"$2,"\011""T" 	T
else if (NR >= domTonicExpansion_3 && NR <= domTonicExpansion_4) 	T
	print $1,"\011"$2,"\011""T" 	T
 	else 	T
 	print $0 }' /tmp/$1.d1 > /tmp/$1.d2 	T
 	T
# #####If V chord in first inversion is tonic expansion. 	T
awk '{ if ($1 ~ /V7a/) 	T
print $1,"\011"$2,"\011""T" 	T
else if ($1 ~ /V7[bc]/) 	T
	print $0 	T
	else print $0 	T
}' /tmp/$1.d2 > /tmp/$1.d3 	T
# 	T
# ####Passing 6/4 as expansion of tonic. (Rule 11) 	T
passingV64_1=$(pattern -f ../patterns/passingV64 /tmp/$1.d3 | head -1 | awk '{print $6}') 	T
passingV64_2=$(pattern -f ../patterns/passingV64 /tmp/$1.d3 | head -1 | awk '{print $9}') 	T
awk -v passingV64_1=$passingV64_1 -v passingV64_2=$passingV64_2 ' 	T
{ if (NR >= passingV64_1 && NR <= passingV64_2) 	T
print $1,"\011"$2,"\011""T" 	T
	else 	T
	print $0 	T
}' /tmp/$1.d3 > /tmp/$1.d4 	T
 	T
# #######V-vii Rules 8 -10TT
# 	T
# 	T
awk '{if ($1 ~ /viio7a/)TT
print 	$1,"\011"$2,"\011""T" 	T
else 	if 	T
print 	$1,"\011"$2,"\011""T" 	T
else if ($1 ~ /viio7c/)TT
print $1,"\011"$2,"\011""D" 	T
else print $0 	T
}' /tmp/$1.d4 > /tmp/$1.d5 	T
# # 	T
# 	T
deceptive_1=$(pattern 	-f 	P
awk -v deceptive_1=$deceptive_1 '{ if (NR==	 deceptive_1) 	T
print $1,"\011"$2,"\011""T" 	T
else print $0 }' /tmp/$1.d5 > /tmp/$1.d6 	T
	T
	T
	T
sed 's/	/	/g' /tmp/$1.d6 | sed 's/	/	/g' |  	T
awk '{if($1 ~ /^\=/) print $1"\011"$2; else if ($1 ~ /^\*\-/) print $1"\011"$2; else print $0}' | awk '{if ($1 ~ /\!/) print $1"\011"$2; 	T
else if ($1 ~ /\*/) print $1"\011"$2;else print $0}' | sed 's/	/	/g' | sed 's/T/T/g' | sed 's///g' | sed 's/T	T/T	T/g' | sed 's/T	T/T	T/g' # > /tmp/$1.cleaned 	T
# # 	T
# 	T
