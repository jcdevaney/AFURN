
############I Chords ##################
####  Rule 1:  Label opening I chords as Tonic
# patt -f ../patterns/openingTonic -t "T" $1 | ditto -s "=\t="
# awk '{if ($3 ~ /=-/) $(NF--)=""; print}' | sed 's/=- /=-	/g'
opening_tonic1=$(pattern -f ../patterns/openingTonic $1 | head -1 | awk '{print $6}')
opening_tonic2=$(pattern -f ../patterns/openingTonic $1 | tail -1 | awk '{print $9}')
awk -v opening_tonic=$opening_tonic1 -v opening_tonic2=$opening_tonic2 '{ if (!NF) print $0
else if (NR > opening_tonic1 && NR == opening_tonic2) 
print $0,"\011""T"
else print $0}' $1  > /tmp/$1.tonicOpening
#
# #### Rule 2: Label closing I chords as tonic (beginning with first appearance of final tonicchord)
closing_tonic_start=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $6}')
closing_tonic_end=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $9}')
awk -v clsSt=$closing_tonic_start -v clsE=$closing_tonic_end '{ if (NR >= clsSt)
print $0,"\011""T";
else print $0
}'  /tmp/$1.tonicOpening  | awk '{if ($3 ~ /==/) $(NF--)=""; print}' | sed 's/==/==	/g' | awk '{if ($3 ~ /\*-/) $(NF--)=""; print}' |
 sed 's/\*-/\*-	/g' | sed 's/ =/=/g' | sed 's/ \*-/\*-/g' > /tmp/$1.tonicClosing
#
# # ####Rule 3: Cadential 6/4 chords.
first_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $6}')
second_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $9}')
awk -v first=$first_line -v second=$second_line '{ if (!NF) print $0
else if(NR==first)
print $0,"\011""D (cadential 64)"
else if (NR==second)
	print $0,"\011""D (cadential 64)"
else print $0}' /tmp/$1.tonicClosing > /tmp/$1.cad64

### Diminished  as Dominant (first fule of V chord section)
awk '{ if ($1 ~ /^.*viio/)
 print $1,"\011"$2,"\011""D (vii as dom.)"
else print $0 }' /tmp/$1.cad64 > /tmp/$1.dominantsubs


awk '{ if ($1 ~ /^.*viio42/)
 print $1,"\011"$2,"\011""D (vii as dom.)"
else print $0 }' /tmp/$1.dominantsubs > /tmp/$1.dominantsubs_vii


# # # #### Tonic Expansion through V #######
texpand1=$(pattern -f ../patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $6}')
texpand2=$(pattern -f ../patterns/tonicDominantExpansion /tmp/$1.dominantsubs_vii | awk '{print $9}')
awk -v texpand1=$texpand1 -v texpand2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2)
	print $1,"\011"$2,"\011""T (Tonic Expansion through Dominant)"
else
	print $0}' /tmp/$1.dominantsubs_vii > /tmp/$1.tonicExpansion

####Tonic Expansion through vii.	
texpand_vii_1=$(pattern -f ../patterns/tonicDominant_vii_Expansion /tmp/$1.tonicExpansion | awk '{print $6}')
texpand_vii_2=$(pattern -f ../patterns/tonicDominant_vii_Expansion /tmp/$1.tonicExpansion | awk '{print $9}')
awk -v texpand_vii_1=$texpand1 -v texpand_vii_2=$texpand2 '{ if (NR >= texpand1 && NR <= texpand2)
	print $1,"\011"$2,"\011""T (Tonic Expansion through vii)"
else
	print $0}' /tmp/$1.tonicExpansion > /tmp/$1.tonicExpansion_vii
	
####Cleaner
sed 's/	 	/	/g' /tmp/$1.tonicExpansion_vii | sed 's/		/	/g' | 
awk '{if($2 ~/\=/) print $1"\011"$2; else if ($2 ~/\*-/) print $1"\011"$2; print $0}' | grep -v "==	T" | grep -v "\*-	T"

# awk 'BEGIN{FS="\t"}{if ($1 ~ /^[0-9]/)
# print $1,"\011"$2,"\011"$3
# else if ($1 ~ /^\=/)
# print $1,"\011"$2,"\011"$3
# else print $0}