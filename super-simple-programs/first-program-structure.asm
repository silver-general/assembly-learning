.nolist ; does not list the following inclusions in the list file 
.include "tn85def.inc" ; Define device ATtiny85 keywords
.list

.cseg         ; code segment: cosa fa di preciso?
.org 000000   ; sets start of program to address 0 of program memory (in SRAM)

Main:
Loop:
	rjmp loop       

