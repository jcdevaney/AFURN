######OPENING SUBSTITUTIONS##########

awk 'BEGIN{FS=","}{if ($1 ~ /^[0-9\.]V/) print $1"\011"$2"\011""D"; 
else if ($1 ~ /[0-9\.]V/) print $1"\011"$2"\011""D"; 
else if ($1 ~ /IV/) print $1"\011"$2"\011""P";
else if ($1 ~ /vi/) print $1"\011"$2"\011""T";
else if ($1 ~ /I[abc]/) print $1"\011"$2"\011""T";
else if ($1 ~ /^[0-9\.][iI]"\011"/) print $1"\011"$2"\011""T";
else print $0}' $1  > /tmp/$1.subbedOpening


############I Chords ##################
####  Rule 1:  Label opening I chords as Tonic
opening_tonic1=$(pattern -f patterns/openingTonic /tmp/$1.subbedOpening | head -1 | awk '{print $6}')
opening_tonic2=$(pattern -f patterns/openingTonic /tmp/$1.subbedOpening | tail -1 | awk '{print $9}')
awk -v opening_tonic=$opening_tonic1 -v opening_tonic2=$opening_tonic2 '{ if (!NF) print $0
else if (NR > opening_tonic1 && NR == opening_tonic2) 
print $0,"\011""T"
else print $0}' /tmp/$1.subbedOpening  > /tmp/$1.tonicOpening

# #### Rule 2: Label closing I chords as tonic (beginning with first appearance of final tonicchord)
closing_tonic_start=$(pattern -f patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $6}')
closing_tonic_end=$(pattern -f patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $9}')
awk -v clsSt=$closing_tonic_start -v clsE=$closing_tonic_end '{ if (NR >= clsSt)
print $0,"\011""T";
else print $0
}'  /tmp/$1.tonicOpening  | awk '{if ($3 ~ /==/) $(NF--)=""; print}' | sed 's/==/==	/g' | awk '{if ($3 ~ /\*-/) $(NF--)=""; print}' |
 sed 's/\*-/\*-	/g' | sed 's/ =/=/g' | sed 's/ \*-/\*-/g' > /tmp/$1.tonicClosing
#
# # ####Rule 3: Cadential 6/4 chords.
first_line=$(pattern -f patterns/cad64 /tmp/$1.tonicClosing | awk '{print $6}')
second_line=$(pattern -f patterns/cad64 /tmp/$1.tonicClosing | awk '{print $9}')
awk -v first=$first_line -v second=$second_line '{ if (!NF) print $0
else if(NR==first)
print $0,"\011""D (cadential 64)"
else if (NR==second)
	print $0,"\011""D (cadential 64)"
else print $0}' /tmp/$1.tonicClosing > /tmp/$1.cad64
#
# ### Diminished  as Dominant (first fule of V chord section)
awk '{ if ($1 ~ /^.*viio/)
 print $1,"\011"$2,"\011""D (vii as dom.)"
else print $0 }' /tmp/$1.cad64 > /tmp/$1.dominantsubs


awk '{ if ($1 ~ /^.*viio42/)
 print $1,"\011"$2,"\011""D (vii as dom.)"
else print $0 }' /tmp/$1.dominantsubs > /tmp/$1.dominantsubs_vii
	
####Enforce phrase model here.
# pseudo code:
# if T is followed by end of example, V before it should be D, ii or IV before it should be P;
# 	if D is followed by end, ii or IV should be labeled P, T before that should be T
# 		if T is followed by end, D before that should be T, and T leading to that should be T
# 			if ends with D, I before that should be tonic.




# # # #### Tonic Expansion through V #######
texpand1=$(pattern -f patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $6}')
texpand2=$(pattern -f patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $9}')
awk -v texpand1=$texpand1 -v texpand2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2)
	print $1,"\011"$2,"\011""T (Tonic Expansion through Dominant)"
else
	print $0}' /tmp/$1.dominantsubs_vii > /tmp/$1.tonicExpansion

####Tonic Expansion through vii.
texpand_vii_1=$(pattern -f patterns/tonicDominant_vii_Expansion /tmp/$1.tonicExpansion | awk '{print $6}')
texpand_vii_2=$(pattern -f patterns/tonicDominant_vii_Expansion /tmp/$1.tonicExpansion | awk '{print $9}')
awk -v texpand_vii_1=$texpand1 -v texpand_vii_2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2)
	print $1,"\011"$2,"\011""T (Tonic Expansion through vii)"
else
	print $0}' /tmp/$1.tonicExpansion > /tmp/$1.tonicExpansion_vii

###Root Position Tonics####
awk '{if ($1 ~ /[0-9]\.[iI]/ && $3 == "") print $1"\011"$2"\011""T"; else if ($1 ~ /[0-9][iI]/ && $3 == "") print $1"\011"$2"\011""T";
 else print $0}' /tmp/$1.tonicExpansion_vii > /tmp/$1.smoothing
	 
#####Smoothing to get rid of multiple dominants in a phrase.	

smooth1=$(pattern -f patterns/smoothing /tmp/$1.smoothing | head -1 | awk '{print $6}')
smooth2=$(pattern -f patterns/smoothing /tmp/$1.smoothing | awk '{print $6}' | uniq | head -2 | tail -1)
awk -v smooth1=$smooth1 -v smooth2=$smooth2 '{ if (NR==smooth1)
	print $1,"\011"$2,"\011""T (Tonic on Higher Level in Phrase Model)"
	else if (NR==smooth2)
	print $1,"\011"$2,"\011""T (Tonic on Higher Level in Phrase Model)"
else
	print $0}' /tmp/$1.smoothing > /tmp/$1.smoothing1	

smooth3=$(pattern -f patterns/smoothing2 /tmp/$1.smoothing1 | head -1 | awk '{print $6}')
smooth4=$(pattern -f patterns/smoothing2 /tmp/$1.smoothing1 | head -1 | awk '{print $9}')
awk -v smooth3=$smooth3 -v smooth4=$smooth4 '{ if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /I/)) print $1,"\011"$2,"\011""T"
else if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /IV/)) print $1,"\011"$2,"\011""P"
else if (NR >= smooth3 && NR <= smooth4 && ($1 ~ /V/)) print $1,"\011"$2,"\011""D"
else print $0
}' /tmp/$1.smoothing1 > /tmp/$1.smoothing2

domdom1=$(pattern -f patterns/domdom /tmp/$1.smoothing2 | head -1 | awk '{print $6}')
domdom2=$(pattern -f patterns/domdom /tmp/$1.smoothing2 | head -1 | awk '{print $9}')
awk -v domdom1=$domdom1 -v domdom2=$domdom2 '{ if (NR >= domdom1 && NR <= domdom2 && ($1 ~ /V/))
print $1,"\011"$2,"\011""D"
else print $0
}' /tmp/$1.smoothing2 > /tmp/$1.smoothing3

domdom3=$(pattern -f patterns/domdom2 /tmp/$1.smoothing3 | head -1 | awk '{print $6}')
domdom4=$(pattern -f patterns/domdom2 /tmp/$1.smoothing3 | head -1 | awk '{print $9}')
awk -v domdom3=$domdom3 -v domdom4=$domdom4 '{ if (NR >= domdom3 && NR <= domdom4)
print $1,"\011"$2,"\011""D"
else print $0
}' /tmp/$1.smoothing3 > /tmp/$1.smoothing4

domdom5=$(pattern -f patterns/domdom3 /tmp/$1.smoothing4 | head -1 | awk '{print $6}')
domdom6=$(pattern -f patterns/domdom3 /tmp/$1.smoothing4 | head -1 | awk '{print $9}')
awk -v domdom5=$domdom5 -v domdom5=$domdom6 '{ if (NR >= domdom5 && NR <= domdom6 && ($3 ~ /D/))
print $1,"\011"$2,"\011""D"
else print $0
}' /tmp/$1.smoothing4 > /tmp/$1.sd


##################ii and IV chord rules#####################
####label ii and IV chords as as P.
awk '{ if ($1 ~ /^.*ii/)
 print $1,"\011"$2,"\011""P"
else if ($1 ~ /^.*IV/) print $1,"\011"$2,"\011""P";
	else if ($1 ~ /^.*iv/) print $1,"\011"$2,"\011""P";
		else print $0 }' /tmp/$1.sd > /tmp/$1.sd1 
#######Arpeggiating as expanding tonic (rule 3)########			
arpP1=$(pattern -f patterns/arpPD /tmp/$1.sd1 | head -1 | awk '{print $6}')
arpP2=$(pattern -f patterns/arpPD /tmp/$1.sd1 | head -1 | awk '{print $9}')

awk -v arpP1=$arpP1 -v arpP2=$arpP2 '{ if (NR >= arpP1 && NR <= arpP2)
print $1,"\011"$2,"\011""T"
else 
	print $0
}' /tmp/$1.sd1 > /tmp/$1.sd2

#####IV6 as expanding dominant. (ii/IV rule 4)

arpP1a=$(pattern -f patterns/arpPDa /tmp/$1.sd2 | head -1 | awk '{print $6}')
arpP2a=$(pattern -f patterns/arpPDa /tmp/$1.sd2 | head -1 | awk '{print $9}')
awk -v arpP1a=$arpP1a -v arpP2a=$arpP2a '{ if (NR >= arpP1a && NR <= arpP2a)
print $1,"\011"$2,"\011""D"
else 
	print $0
}' /tmp/$1.sd2 > /tmp/$1.sd3

######Plagal Motion (IV)
arpP1b=$(pattern -f patterns/arpPDb /tmp/$1.sd3 | head -1 | awk '{print $6}')
arpP2b=$(pattern -f patterns/arpPDb /tmp/$1.sd3 | head -1 | awk '{print $9}')
awk -v arpP1b=$arpP1b -v arpP2b=$arpP2b '{ if (NR >= arpP1b && NR <= arpP2b)
print $1,"\011"$2,"\011""T"
else 
	print $0
}' /tmp/$1.sd3 > /tmp/$1.sd4
######Plagal Motion (ii65)
arpP1c=$(pattern -f patterns/arpPDc /tmp/$1.sd4 | head -1 | awk '{print $6}')
arpP2c=$(pattern -f patterns/arpPDc /tmp/$1.sd4 | head -1 | awk '{print $9}')
awk -v arpP1c=$arpP1c -v arpP2c=$arpP2c '{ if (NR >= arpP1c && NR <= arpP2c)
print $1,"\011"$2,"\011""D"
else 
	print $0
}' /tmp/$1.sd4 > /tmp/$1.sd5

##########iii chords 
###Make all iii chords into Tonic function and all bIII into P (rules 1 and 2)
awk '{ if ($1 ~ /iii/)
print $1,"\011"$2,"\011""T"
else if ($1 ~ /bIII/)
	print $1,"\011"$2,"\011""P"
	print $0
}' /tmp/$1.sd5 > /tmp/$1.iii

## V and vii chords.
# Rule 1 (vii chords are dominant)
awk '{ if ($1 ~ /vii/)
print $1,"\011"$2,"\011""D"
else 
	print $0
}' /tmp/$1.iii > /tmp/$1.d1

##Rule 2 (V6 and viio6 chords can expand tonic function when acting as a neighbor between two root position 
# I chords or as passing between I and I6)
domTonicExpansion_1=$(pattern -f patterns/domexpansion_1 /tmp/$1.d1 | head -1 | awk '{print $6}')
domTonicExpansion_2=$(pattern -f patterns/domexpansion_1 /tmp/$1.d1 | head -1 | awk '{print $9}')
domTonicExpansion_3=$(pattern -f patterns/domexpansion_2 /tmp/$1.d1 | head -1 | awk '{print $6}')
domTonicExpansion_4=$(pattern -f patterns/domexpansion_2 /tmp/$1.d1 | head -1 | awk '{print $9}')
awk -v domTonicExpansion_1=$domTonicExpansion_1 -v domTonicExpansion_2=$domTonicExpansion_2  -v domTonicExpansion_3=$domTonicExpansion_3 -v domTonicExpansion_4=$domTonicExpansion_4 '{ if (NR >= domTonicExpansion_1 && NR <= domTonicExpansion_2)
print $1,"\011"$2,"\011""T"
else if (NR >= domTonicExpansion_3 && NR <= domTonicExpansion_4)
	print $1,"\011"$2,"\011""T"
 	else
 	print $0 }' /tmp/$1.d1 > /tmp/$1.d2

# #####If V chord in first inversion is tonic expansion.
awk '{ if ($1 ~ /V7a/)
print $1,"\011"$2,"\011""T"
else if ($1 ~ /V7[bc]/)
	print $0
	else print $0
}' /tmp/$1.d2 > /tmp/$1.d3
#
# ####Passing 6/4 as expansion of tonic. (Rule 11)
passingV64_1=$(pattern -f patterns/passingV64 /tmp/$1.d3 | head -1 | awk '{print $6}')
passingV64_2=$(pattern -f patterns/passingV64 /tmp/$1.d3 | head -1 | awk '{print $9}')
awk -v passingV64_1=$passingV64_1 -v passingV64_2=$passingV64_2 '
{ if (NR >= passingV64_1 && NR <= passingV64_2)
print $1,"\011"$2,"\011""T"
	else
	print $0
}' /tmp/$1.d3 > /tmp/$1.d4

# #######V-vii Rules 8 -10
#
#
awk '{if ($1 ~ /viio7a/)
print $1,"\011"$2,"\011""T"
else if ($1 ~ /viio7b/)
print $1,"\011"$2,"\011""T"
else if ($1 ~ /viio7c/)
print $1,"\011"$2,"\011""D"
else print $0
}' /tmp/$1.d4 > /tmp/$1.d5
# #
#
deceptive_1=$(pattern -f patterns/deceptiveCadence /tmp/$1.d4 | head -1 | awk '{print $9}')
awk -v deceptive_1=$deceptive_1 '{ if (NR == deceptive_1)
print $1,"\011"$2,"\011""T"
else print $0 }' /tmp/$1.d5 > /tmp/$1.d6
	
	
	
sed 's/	 	/	/g' /tmp/$1.d6 | sed 's/	 	/	/g' | 
awk '{if($1 ~ /^\=/) print $1"\011"$2; else if ($1 ~ /^\*\-/) print $1"\011"$2; else print $0}' | awk '{if ($1 ~ /\!/) print $1"\011"$2;
else if ($1 ~ /\*/) print $1"\011"$2;else print $0}' | sed 's/		/	/g' | sed 's/	T 	/T/g' | sed 's/	 T	//g' | sed 's/TTT/T	T/g' | sed 's/T TT/T	T/g' # > /tmp/$1.cleaned
# #
#
