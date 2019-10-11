.nolist ; does not list the following inclusions in the list file 
.include "tn85def.inc" ; Define device ATtiny85 keywords
.list

.cseg         ; code segment: tells the assembler to write the following in the Program Memory (flash ROM)
.org 000000   ; sets start of program to address 0 of program memory (in flash ROM)

Main:
Loop:
	rjmp loop       

