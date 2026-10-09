rem test bug 188,189,190
rem 820 chip example follows
asmcop cop820/l/local/noconstant/ch=820
asmcop cop820a/l/local/noconstant/ch=820
lncop cop820,cop820a /table/f=hex
rem same link with one module in library follows
libcop cop820 cop820a/r
lncop cop820 /lf=cop820/o=cop8201/m=cop8201/table/f=hex
rem special chip example to override 820 chip follows
rem see copxxx.fil for new ranges
asmcop cop820/l=copxxx/d=SPECIAL/local/noconstant/ch=820
asmcop cop820a /l=copxxxa /d=SPECIAL/local/noconstant/ch=820
lncop cop820,cop820a   /fil=copxxx /o=copxxx/m=copxxx/table/f=hex
rem special chip example now with /model=medium follows
rem see .lis files for different size jumps
asmcop cop820/l=copxxx1/d=SPECIAL/model=medium/local/noconstant/ch=820
asmcop cop820a /l=copxxx1a/d=SPECIAL /model=medium/local/noconstant/ch=820
lncop cop820,cop820a   /fil=copxxx /o=copxxx1/m=copxxx1/table/f=hex
rem special chip example now with /model=large  follows
rem see .lis files for different size jumps
asmcop cop820/l=copxxx2/d=SPECIAL/model=large/local/noconstant/ch=820
asmcop cop820a /l=copxxx2a/d=SPECIAL  /model=large/local/noconstant/ch=820
lncop cop820,cop820a   /fil=copxxx /o=copxxx2/m=copxxx2/table/f=hex
echo n | comp *.hex *.h
command/c dif cop820.map cop820.m
