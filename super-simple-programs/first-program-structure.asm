
; tutorial at: http://www.avr-asm-tutorial.net/avr_en/starter/starter.html
; FOR ATtiny85!!!

; include attiny85 key words, don't list them into the assembled code
.nolist
.include "tn85def.inc" ; Define device ATtiny85
.list   

.def rSreg = R15 ; Save/Restore status port  ;????????????????
.def rmp = R16 ; Define multipurpose register   

.dseg
.org SRAM_START                          

.cseg         ; instructs the assembler to produce code ??????????????
.org 000000   ; sets starting point to address 0! 

;.... stuff. see avr-sim basic template

; main program loop 
Loop:
  rjmp Loop




