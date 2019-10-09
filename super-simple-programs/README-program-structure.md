# birth of a program

1. write an *.asm program
2. assembler translates it into machine code
3. something converts it into hexadecimal for AVR architecture? not sure ..............->>>>???

# when the AVR microcontroller powers up
1. reset event: program counter is set to address 0 (unless told otherwise) of program memory (Flash)
2. fetch-execute of first instruction (remember: pipeline,2 levels), then second, etc



# To understand the code, look up things on https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html

# MOST BASIC FILE.ASM

```
.nolist
.include "tn85def.inc" ; Define device ATtiny85
.list
;
.cseg                    ; tells the assembler that the following text is code segment
.org 000000              ; sets start address of code segment

Main:
Loop:
NOP
rjmp loop
            
```

# COMPLETE FILE.ASM
```
;
; ***********************************
; * (Add program task here)         *
; * (Add AVR type and version here) *
; * (C)2019 by Gerhard Schmidt      *
; ***********************************
;
.nolist
.include "tn85def.inc"                        ; Define device ATtiny85
.list
;



; **********************************
;        H A R D W A R E
; **********************************
;
; (F2 adds ASCII pin-out for device here)
;



; **********************************
;  P O R T S   A N D   P I N S
; **********************************
;
; (Add symbols for all ports and port pins with ".equ" here)
; (e.g. .equ pDirD = DDRB ; Define a direction port
;  or
;  .equ bMyPinO = PORTB0 ; Define an output pin)
;



; **********************************
;   A D J U S T A B L E   C O N S T
; **********************************
;
; (Add all user adjustable constants here, e.g.)
; .equ clock=1000000 ; Define the clock frequency
;



; **********************************
;  F I X  &  D E R I V.  C O N S T
; **********************************
;
; (Add symbols for fixed and derived constants here)
;



; **********************************
;       R E G I S T E R S
; **********************************
;
; free: R0 to R14
.def rSreg = R15 ; Save/Restore status port
.def rmp = R16 ; Define multipurpose register
; free: R17 to R29
; used: R31:R30 = Z for ...
;



; **********************************
;           S R A M
; **********************************
;
.dseg
.org SRAM_START
; (Add labels for SRAM locations here, e.g.
; sLabel1:
;   .byte 16 ; Reserve 16 bytes)
;



; **********************************
;         C O D E
; **********************************
;
.cseg           ;tells the assembler that the following text is code segment
.org 000000     ;sets start address of code segment



;
; **********************************
; R E S E T  &  I N T - V E C T O R S
; **********************************
	rjmp Main ; Reset vector
	reti ; INT0
	reti ; PCI0
	reti ; OC1A
	reti ; OVF1
	reti ; OVF0
	reti ; ERDY
	reti ; ACI
	reti ; ADCC
	reti ; OC1B
	reti ; OC0A
	reti ; OC0B
	reti ; WDT
	reti ; USI_START
	reti ; USI_OVF



;
; **********************************
;  I N T - S E R V I C E   R O U T .
; **********************************
;
; (Add all interrupt service routines here)
;



; **********************************
;  M A I N   P R O G R A M   I N I T
; **********************************
;
Main:
.ifdef SPH ; if SPH is defined
  ldi rmp,High(RAMEND)
  out SPH,rmp ; Init MSB stack pointer
  .endif
	ldi rmp,Low(RAMEND)
	out SPL,rmp ; Init LSB stack pointer
; ...
	sei ; Enable interrupts



;
; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:                                       ; main program loop
	rjmp loop
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
;                                                     
```
