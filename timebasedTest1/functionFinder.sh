
############I Chords ##################
####  Rule 1:  Label opening I chords as Tonic
# patt -f ../patterns/openingTonic -t "T" $1 | ditto -s "=\t="
# awk '{if ($3 ~ /=-/) $(NF--)=""; print}' | sed 's/=- /=-	/g'
opening_tonic=$(pattern -f ../patterns/openingTonic $1 | head -1 | awk '{print $9}')
awk -v opening_tonic=$opening_tonic '{ if (!NF) print $0
else if (NR==opening_tonic)
print $0,"\011""T"
else print $0"\011""."}' $1  #> /tmp/$1.tonicOpening

#### Rule 2: Label closing I chords as tonic (beginning with first appearance of final tonicchord)
closing_tonic_start=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $6}')
closing_tonic_end=$(pattern -f ../patterns/closingTonic /tmp/$1.tonicOpening | head -1 | awk '{print $9}')
awk -v clsSt=$closing_tonic_start -v clsE=$closing_tonic_end '{ if (NR >= clsSt)
print $0,"\011""T";
else print $0
}'  /tmp/$1.tonicOpening  | awk '{if ($3 ~ /==/) $(NF--)=""; print}' | sed 's/==/==	/g' | awk '{if ($3 ~ /\*-/) $(NF--)=""; print}' |
 sed 's/\*-/\*-	/g' | sed 's/ =/=/g' | sed 's/ \*-/\*-/g' > /tmp/$1.tonicClosing

# # ####Rule 3: Cadential 6/4 chords.
first_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $6}')
second_line=$(pattern -f ../patterns/cad64 /tmp/$1.tonicClosing | awk '{print $9}')
awk -v first=$first_line -v second=$second_line '{ if (!NF) print $0
else if(NR==first)
print $0,"\011""D (cadential 64)"
else if (NR==second)
	print $0,"\011""D (cadential 64)"
else print $0"\011""."}' /tmp/$1.tonicClosing > /tmp/$1.cad64

####Rule 4:	PD Expansion through a I chord.

pd_expand1=$(pattern -f ../patterns/pdExpansion /tmp/$1.cad64 | awk '{print $6}')
pd_expand2=$(pattern -f ../patterns/pdExpansion /tmp/$1.cad64 | awk '{print $9}')
awk -v pd_expand1=$first_line -v pd_expand2=$second_line '{ if (NR>=pd_expand1&&<=pd_expand2)
print $0,"\011""P"
else print $0"\011""."}' /tmp/$1.cad64 #> /tmp/$1.pdExpand

#### Rule 5 (Pedal tones) Pedal Predominant Version
pedSD1=$(pattern -f ../patterns/pedSD /tmp/$1.pdExpand | awk '{print $6}')
pedSD2=$(pattern -f ../patterns/pedSD /tmp/$1.pdExpand | awk '{print $9}')
awk -v pd_expand1=$first_line -v pd_expand2=$second_line '{ if (NR>=pedSD1 && <= pedSD2)
print $0,"\011""P"
else print $0"\011""."}' tmp/$1.pdExpand
# 	#
# # #### Rule 5 Pedal Tonic ########STOPPED HERE
# # ped=$(pattern -f ../patterns/pedSD /tmp/$1.pdExpand | awk '{print $6}')
# # pedSD2=$(pattern -f ../patterns/pedSD /tmp/$1.pdExpand | awk '{print $9}')
# # awk -v pd_expand1=$first_line -v pd_expand2=$second_line '{ if (NR>=pedSD1 && <= pedSD2)
# # print $0,"\011""P"
# # else print $0"\011""."}' tmp/$1.pdExpand
# #
#
#
# 	###Cleaner
# #sed 's/		/	/g' /tmp/$1.cleaner