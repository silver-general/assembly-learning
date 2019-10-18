```
;
; ***********************************
; * PROGRAM COUNTS SECONDS, MINUTES, HOURS *
; * ATtiny85 *
; * (C)2019 by Alberto Morgana        *
; ***********************************
;
.nolist
.include "tn85def.inc" ; Define device ATtiny85
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
.def InterrNumb = R17		; numero di interrupt. appena raggiunge 230, è 1 min!-> incremento registro minuti!
.def minutes = R18		; numero minuti. quando raggiunge 1440, ho raggiunto 12 ore!
.def hours = R19
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
.cseg
.org 000000
;
; **********************************
; R E S E T  &  I N T - V E C T O R S
; **********************************
	rjmp Main ; Reset vector
	reti ; INT0
	reti ; PCI0
	reti ; OC1A
	reti ; OVF1
	rjmp Ovf0Isr ; OVF0 interrupt vector
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
;  I N T - S E R V I C E   R O U T . (Add all interrupt service routines here)

; **********************************
Ovf0Isr:
	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15)
	; generic code if you need. DO NOT modify rSreg (R15)!

	INC InterrNumb			; increment interruption number register                             ; REGISTRI IN USO
	CPI InterrNumb, 229		; InterrNumb==229 -> Z==1                                          ; rSreg(R15): status register address
	BREQ minuteDone				; Z==1 -> branch to minutedone!                                    ; InterrNum(R17): interrupts number
Ovf0Isr_end:                                                                               ; minutes(R18): minute number
	out SREG,rSreg			; restore status register from temporary register                    ; hours(R19): hour number
	RETI				; return from interrupt subroutine

minuteDone:
	INC minutes			; incremento di 1 i minuti
  CPI minutes,60  ; minutes==60 -> Z == 1
  BREQ hourDone   ; z==1 <-> minutes == 60 -> incremento le ore!
minuteDoneEnding:                                          ; this label is useless! but I added it for symmetry to Ovf0Isr block
	rjmp Ovf0Isr_end

hourDone:
  INC hours
  rjmp Ovf0Isr_end
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


; ***** TIMER *****
; this timer start here and ticks forever
; TIMER MODE: see "TCCR0A - Timer/Counter  Control Register A"
; default is "normal" -> 0:0 in bites 1:0 -> no operation needed for a simple timer!

; ENABLE COUNTER OVERFLOW FLAG   -> see manual, 11.9.7
ldi R16,1<<TOIE0                 ; TOIE0 is the bit1 int TIMSK, timer counter interrupt mask register
out TIMSK,R16                    ;

; TIMER SPEED: see "TCCR0B - Timer/Counter Control Register B" in the include file to use CS00,CS01,...
ldi R16, (1<<CS00)|(1<<CS02)    ; 00000101 -> clock/1024 mode; 00000001 -> clock mode
out TCCR0B, R16                 ; sets the bits in the timer control register -> timer activated!
				; counts every 1024 clock cycles
				; if 1 clk is 1 ns -> counts every 1024ns = 1.024ms


; ANALISI
; il timer parte: 10 istruzioni, 11ns
;
; a) 1tick/clk: aspettative: primo interrupt dopo 0.256 ms
;               realtà:      interrupt: 1st at 271ns, 2nd at 526ns, 3rd at 783ns so about 255-257ns each
; DOMANDA: di quanto è l'errore? di quanto me lo porto dietro, dopo 12h?
;
; 1tick/(1024clk): aspettative: primo interrupt dopo 262.144 ms!
;



;*****SLEEP MODE ENABLING*****
LDI R16,(1<<SE) ; NOTE: SE is a constant, value 5
OUT MCUCR, R16

; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:
;	*****SLEEP ACTIVATION*****

	SLEEP
	rjmp loop
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
;     
```
