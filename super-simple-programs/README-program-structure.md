
# Table of Contents
0. [references](#references)
1. [birth of a program](#birth-of-a-program)
2. [events on power up](#events-on-power-up)
3. [smallest file in asm](#smallest-file-in-asm)
4. [complete file in asm](#complete-file-in-asm)
5. [complete file list](#complete-file-list)



## references
official documentation: https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html
step-by-step tutorial: http://www.avr-asm-tutorial.net/avr_en/starter/starter.html

## birth of a program
1. write an *.asm program
2. use the compiler (assembler) to translate it into machine code (or list file??????????????)
3. something converts it into hexadecimal for AVR architecture? not sure ..............->>>>???
**find a good explanation**

## events on power up
1. reset event: program counter is set to address 0 (unless told otherwise) of program memory (Flash)
2. fetch-execute of first instruction (remember: pipeline,2 levels)
3. execution of second instruction, simultanaously fetching the third, et cetera
**you can write this better**

## smallest file asm

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
## complete file in asm
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
	INC R1		; increments R1
	INC R2		; same for R"
	MOV R3,R1	; copies R1 into R3
	ADD R3,R2	; adds R2 to R3 
	rjmp loop	; jumps to Loop
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
;                                                     
```
## complete file list 
* (after assembling,contains info and expressione translated)
* each instruction has: *address of cell, hexadecimal instruction (usually 16bit), original command mnemonics*

```
gavrasm Gerd's AVR assembler version 4.3 (C)2019 by DG4FAC
----------------------------------------------------------
Path:        /home/alberto/Desktop/EMG/assembly/av_sim/programs/
Source file: 02_copy_add_loop.asm
Hex file:    02_copy_add_loop.hex
Eeprom file: 02_copy_add_loop.eep
Compiled:    09.10.2019, 14:44:05
Pass:        2
     1: ;
     2: ; ***********************************
     3: ; * (Add program task here)         *
     4: ; * (Add AVR type and version here) *
     5: ; * (C)2019 by Gerhard Schmidt      *
     6: ; ***********************************
     7: ;
     8: .nolist
    11: 
    12: 
    13: 
    14: 
    15: ;
    16: ; **********************************
    17: ;        H A R D W A R E
    18: ; **********************************
    19: ;
    20: ; (F2 adds ASCII pin-out for device here)
    21: ;
    22: ; **********************************
    23: ;  P O R T S   A N D   P I N S
    24: ; **********************************
    25: ;
    26: ; (Add symbols for all ports and port pins with ".equ" here)
    27: ; (e.g. .equ pDirD = DDRB ; Define a direction port
    28: ;  or
    29: ;  .equ bMyPinO = PORTB0 ; Define an output pin)
    30: ;
    31: ; **********************************
    32: ;   A D J U S T A B L E   C O N S T
    33: ; **********************************
    34: ;
    35: ; (Add all user adjustable constants here, e.g.)
    36: ; .equ clock=1000000 ; Define the clock frequency
    37: ;
    38: ; **********************************
    39: ;  F I X  &  D E R I V.  C O N S T
    40: ; **********************************
    41: ;
    42: ; (Add symbols for fixed and derived constants here)
    43: ;
    44: ; **********************************
    45: ;       R E G I S T E R S
    46: ; **********************************
    47: ;
    48: ; free: R0 to R14
    49: .def rSreg = R15 ; Save/Restore status port
    50: .def rmp = R16 ; Define multipurpose register
    51: ; free: R17 to R29
    52: ; used: R31:R30 = Z for ...
    53: ;
    54: ; **********************************
    55: ;           S R A M
    56: ; **********************************
    57: ;
    58: .dseg
    59: .org SRAM_START
    60: ; (Add labels for SRAM locations here, e.g.
    61: ; sLabel1:
    62: ;   .byte 16 ; Reserve 16 bytes)
    63: ;
    64: ; **********************************
    65: ;         C O D E
    66: ; **********************************
    67: ;
    68: .cseg
    69: .org 000000
    70: ;
    71: ; **********************************
    72: ; R E S E T  &  I N T - V E C T O R S
    73: ; **********************************
    74: 000000   C00E  rjmp Main ; Reset vector
    75: 000001   9518  reti ; INT0
    76: 000002   9518  reti ; PCI0
    77: 000003   9518  reti ; OC1A
    78: 000004   9518  reti ; OVF1
    79: 000005   9518  reti ; OVF0
    80: 000006   9518  reti ; ERDY
    81: 000007   9518  reti ; ACI
    82: 000008   9518  reti ; ADCC
    83: 000009   9518  reti ; OC1B
    84: 00000A   9518  reti ; OC0A
    85: 00000B   9518  reti ; OC0B
    86: 00000C   9518  reti ; WDT
    87: 00000D   9518  reti ; USI_START
    88: 00000E   9518  reti ; USI_OVF
    89: ;
    90: ; **********************************
    91: ;  I N T - S E R V I C E   R O U T .
    92: ; **********************************
    93: ;
    94: ; (Add all interrupt service routines here)
    95: ;
    96: ; **********************************
    97: ;  M A I N   P R O G R A M   I N I T
    98: ; **********************************
    99: ;
   100: Main:
   101: .ifdef SPH ; if SPH is defined
   102: 00000F   E002  ldi rmp,High(RAMEND)
   103: 000010   BF0E  out SPH,rmp ; Init MSB stack pointer
   104:   .endif
   105: 000011   E50F  ldi rmp,Low(RAMEND)
   106: 000012   BF0D  out SPL,rmp ; Init LSB stack pointer
   107: ; ...
   108: 000013   9478  sei ; Enable interrupts
   109: ;
   110: ; **********************************
   111: ;    P R O G R A M   L O O P
   112: ; **********************************
   113: ;
   114: Loop:
   115: 000014   9413  INC R1
   116: 000015   9423  INC R2
   117: 000016   2C31  MOV R3,R1
   118: 000017   0C32  ADD R3,R2
   119: 000018   CFFB  rjmp loop
   120: ;
   121: ; End of source code
   122: ;
   123: ; (Add Copyright information here, e.g.
   124: ; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
   125: ; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
   126: ;
List of symbols:
Type nDef nUsed             Decimalval           Hexval Name
  T     1     1                      38               26 ATTINY85
  L     1     2                      15               0F MAIN
  L     1     2                      20               14 LOOP
  R     1     0                      15               0F RSREG
  R     1     4                      16               10 RMP
   No macros.
   
Program             :       25 words.
Constants           :        0 words.
Total program memory:       25 words.
Eeprom space        :        0 bytes.
Data segment        :        0 bytes.
Compilation completed, no errors.
Compilation endet 09.10.2019, 14:44:05
```
