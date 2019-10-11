.nolist 		; does not list the following inclusions (the include file) in the list file, cos' it's long
.include "tn85def.inc" 	; Define device ATtiny85 keywords
			; many memory address have names to be used more easily
.list

.cseg         ; code segment: tells the assembler to write the following in the Program Memory (flash ROM)
.org 000000   ; sets start of program to address 0 of program memory (in flash ROM)

Main:
Loop:
	rjmp loop       

