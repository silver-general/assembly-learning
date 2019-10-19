* dopo aver imparato a contare secondi, minuti, ore: devo attivare un pin in OUTPUT e fornire voltaggio HIGH quando raggiungo 8h. 
* metto un controllo ogni volta che incremento l'ora, se il registro arriva a 8: resetto ore, min, sec, partono 10s di sprinkling
* NOTA: il timer continua durante lo sprinkling, ma il prossimo interrupt è in 1024 cicli, quindi plenty of time per finire le subroutines.
* nota: quando attivo la porta come out, posso anche rimettere a dormire o continuare 

#### quindi
raggiungo 8h, è il momento di settare un pin in output e HIGH. 

* quando entro in hourDone incremento le ore, se arrivo a 8 resetto minuti e ore, accendo il pin0 su HIGH.
* come lo spengo poi?		
  * metto dei nop in loop sotto la stessa subroutine (sono in un interrupt, non posso averne altri)
  * accendo, esco dalla subroutine, poi riaccendo
* uso un registro per segnalare lo sprinkle mode? 


# codice
* uso un registro per sapere se è in modalità sprinkle o no:	
	* sprinkle_on è settato a 1 dopo 8 ore, settato a 0 dopo 10s
	* sprinkle_on==0 -> no sprinkle, sprinkle_on==1 -> sprinkling!
	* se sprinkle_on==1, conto gli interrupts (per avere 10s: 39 interrupts se 1interrupt/256*1024 cicli clock)

```
;
; ***********************************
; * PROGRAM opens output each minute for 10s *
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
.def sprinkle_on = R20 ; R20==0 no sprinkle, R20==1 sprinkle,10s!
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
	; DO NOT modify rSreg (R15)!

  INC InterrNumb			; increment interruption number register                             ; REGISTRI IN USO

  ; SE sprinkle_on==1 devo contare 10s=39 interrupts!
  CPI sprinkle_on, 1 ;
  BRNE continue        ; se non è attivo: salta la parte in cui controlli che i secondi siano < 10!

; this happens if sprinkle is 1
; have 10 seconds passed?   if 39 is reached, stop sprinkling-> set sprinkle_on to 0
  CPI InterrNumb, 39
  BRNE continue  ; if 39 is not reached -> continue below

; this happens if 39 is reached: end sprinkling!
  LDI sprinkle_on,0

continue:
  CPI InterrNumb, 229		; InterrNumb==229 -> Z==1                                          ; rSreg(R15): status register address
	BREQ minuteDone				; Z==1 -> branch to minutedone!                                    ; InterrNum(R17): interrupts number
Ovf0Isr_end:                                                                               ; minutes(R18): minute number
	out SREG,rSreg			; restore status register from temporary register                    ; hours(R19): hour number
	RETI				; return from interrupt subroutine

minuteDone:                                                                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	INC minutes			; incremento di 1 i minuti
  CPI minutes,60  ; minutes==60 -> Z == 1
  BREQ hourDone   ; z==1 <-> minutes == 60 -> incremento le ore!
minuteDoneEnding:                                          ; this label is useless! but I added it for symmetry to Ovf0Isr block
	rjmp Ovf0Isr_end

hourDone:
  INC hours
  CPI hours,8      ; hours==8 -> Z == 1
  BREQ sprinkle    ; after 8 hours: reset timer seconds, minutes,hours, activate sprinkle_on!
  rjmp Ovf0Isr_end

;*****SPRINKLE*****
sprinkle:            ; azzero r18, r19 (minuti, ore), attivo modalità sprinkle, torno al main
ldi minutes,0
ldi hours, 0
ldi sprinkle_on,1
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
ldi R16, (1<<CS00)|(1<<CS02)    ; 00000101 -> clock/1024 mode; 00000001 -> clock mode                                     ;;;;;;;;;;;;;;;
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
;*****SET PIN0 OF PORTB AS OUTPUT and LOW*****
sbi DDRB, DDB0 ; sets data direction register bit 1 -> output
cbi PORTB,PORTB0

;*****SLEEP MODE ENABLING*****
LDI R16,(1<<SE) ; NOTE: SE is a constant, value 5
OUT MCUCR, R16




; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:
; - - - - - ACTIVATE SLEEP
SLEEP

; - - - - - se lo sprinkle mode è attivato -> jump to sprinkle_activate
CPI sprinkle_on, 1
BREQ sprinkle_activate
; -----------
; -----------
; -----------

rjmp loop


; * * * * * 10s_sprinkle * * * * *
; per quanto tempo? 10s. se ho 1interrupt ogni 256ms -> ogni 39 interrupts -> segno nel blocco dove incremento interruptNum
sprinkle_activate:
sbi PORTB,PORTB0      ; open pin0 of port B as output, high
rjmp loop



sprinkle_inactivate:
cbi PORTB,PORTB0
rjmp loop
;
;
;
;
;
;
;
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format         
```
