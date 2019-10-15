1. [continua](#continua)
2. [complete code](#complete-code)
# references
* date and time http://www.avr-asm-tutorial.net/avr_en/apps/dcf77_m16/datetime/datetime.html

## questions
1. do I need the global interrupt enabler?
2. how do I implement sleep as a subroutine (to call it as a function)?
3. come mai se jumpo dal loop all'interrupt poi mi dice che lo stack pointer è fuori range? non si fa, vero?
# SETTING A TIMER
using the ATtiny85 8-bit timer/counter0. see official documentation, chapter 11 

## enabling global interrupts
* in the default template in AVR-sim is already set.
* WHERE: "MAIN PROGRAM INIT" section


## selection of timer mode, overflow flag, speed.
* WHERE: put this in the main block, but outside the program loop! but if it goes to sleep, maybe it's also ok in the loop.
```
; TIMER MODE: see "TCCR0A - Timer/Counter0  Control Register A"
; default is "normal" -> 0:0 in bites 1:0 -> no operation needed for a simple timer!

; ENABLE COUNTER OVERFLOW FLAG   -> see manual, 11.9.7
ldi R16,1<<TOIE0                 ; TOIE0 is the bit1 int TIMSK, timer counter 0 interrupt mask register    
out TIMSK,R16                    ; not whenever it overflows an interruption happens! -> see OVF0 in "interrupt vectors"

; TIMER SPEED: see "TCCR0B - Timer/Counter0 Control Register B" in the include file to use CS00,CS01,...
; CHOOSE 1, COMMENT THE OTHERS:
;clr R16                          ; 00000000 -> no timer
ldi R16, 1<<CS00                  ; 00000001 -> clk mode -> 1 tick / clock cycle. 10^6s=1micros for 1 clock cycle
;ldi R16, (1<<CS00)|(1<<CS02)     ; 00000101 -> clk/1024 mode -> if clk is 10^6 -> this is what I need!

out TCCR0B, R16                  ; sets the bits in the timer control register
```
## handling timer overflow interrupt
* when a timer0 overflow interrupt happens (when the counter ticks 255 times) an interrupt happens and the program counter is redirected to the program vector OVF0. there you must put a relative jump "rjmp Ovf0Isr" to the subroutine that you call Ovf0Isr in the "INT SERVICE ROUT." (interruption service routines) section 
* WHERE: select the interrupt vector OVF0, corrsponding to the timer0 overflow interrupt and put there a jump to the Ovf0Isr subroutine (in "INT SERVICE ROUT.") 
```
rjmp Ovf0Isr ; OVF0 interrupt vector
```
* WHERE: Ovf0Isr is located in the "INT SERVICE ROUT" section
	* remember to save the status register SREG into a temporary register sReg (R15, defined in the include file)
	* do something if you need, thwn restore status register SREG from temporary register rSreg (R15)
	* RETI to return to previous location
```
Ovf0Isr: 
	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15)
	; generic code if you need. DO NOT modify rSreg (R15)!
	out SREG,rSreg			; restore status register from temporary register
	RETI				; return from interrupt subroutine
```

## how to count minutes

Once you are in the timer0 overflow subroutine, you must sign somewhere that about 1024ns + the nanoseconds prior the timer settings ( that you can ignore because it's very little time) have passed -> use a couple of register depending on how much info you need.

#### note sulla velocità di tick
* 1tick/clk: 1 tick takes 1ns -> 1 interrupt takes 256 ticks, that is 256ns -> 3906.25 interrupts/s
* 1tick/(1024clk): 1 tick takes 1024ns->1 interrupt takes 256x1024ns=262144ns->3.8169 interrupts/s->**228.88interrupts/s**

1. when the clock ticks, the timer counter increments. when it reaches 256, a timer overflow interrupt happens. when it happens, I can say that 1024x256 ticks have occurred -> 1.024ms x 256 = 262144ns-> 1 TIMER OVERFLOW EVERY 262144ns!
2. per ogni timer overflow interrupt (quindi per ogni 262144ns) incremento un valore in un registro, diciamo R17. R17 tiene fino al numero 255 valori, quindi aumento R17 finchè non overflowa (diventa = 0). SE R17 diventa 0, ho fatto 256x256 interruzioni -> tantissime.
3. OPPURE: ho un interrupt ogni 262144ns -> ho un secondo ogni 3.8147 interrupts -> **un minuto ogni 228.88 interrupts** (che stanno in 1byte!)

## caso: conta fino a 24h
facciamolo: ogni interrupt (ovvero: dopo 262.144ms) incremento il registro degli interrupts (InterrNum) e quando arriva a 229 (errore dello 0.0001! sotto il millesimo di secondo!) aumento il registro dei minuti (minuti) e quando arriva a ORETOTALI ho finito! con ORETOTALI: scegli. per adesso, facciamo 24.

```
; REGISTRI IN USO
; rSreg(R15): status register address
; InterrNum(R17): interrupts number
; hours(R19): hour number

Ovf0Isr:
	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15). DO NOT MODIFY R15!

	INC InterrNumb			; increment interruption number register                             
	CPI InterrNumb, 229		; InterrNumb==230 -> Z==1                                          
	BREQ minuteDone				; Z==1 -> branch to minutedone!				
	Ovf0Isr_end:                  	; minutes(R18): minute number
	out SREG,rSreg			; restore status register from temporary register                    
	RETI				; return from interrupt subroutine

minuteDone:
	INC minutes			; incremento di 1 i minuti
  	CPI minutes,60  		; minutes==60 -> Z == 1
  	BREQ hourDone   		; z==1 <-> minutes == 60 -> incremento le ore!
minuteDoneEnding:                 	; this label is useless! but I added it for symmetry to Ovf0Isr block
	rjmp Ovf0Isr_end       
	
```
# continua
controlla su tablet le annotazioni su samsung notes, fà partire il simulatore e mandalo a dormire (sennò il loop brucia 2 ns!

# SETTING SLEEP
sleep mode is controlled by MCUCR: microcontroller unit control register. contains power management bits

## enable sleep mode
* bit5 is called SE: sleep enable. set this to 1  
	* WHERE: in the "MAIN PROGRAM INIT"
``` 
LDI R16,(1<<SE) ; NOTE: SE is a constant, value 5
OUT MCUCR, R16 
```
* bit4, bit3: sleep mode. by default they are cleared -> idle mode, so don't worry about it.

## make it sleep
* use SLEEP command
	* WHERE: in the "PROGRAM LOOP"

# complete code
```
;
; ***********************************
; * PROGRAM COUNTS TO 1 SECOND        *
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
	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15). DO NOT MODIFY R15!

	INC InterrNumb			; increment interruption number register                             
	CPI InterrNumb, 230		; InterrNumb==230 -> Z==1                                          
	BREQ minuteDone				; Z==1 -> branch to minutedone!				
	Ovf0Isr_end:                  	; minutes(R18): minute number
	out SREG,rSreg			; restore status register from temporary register                    
	RETI				; return from interrupt subroutine

minuteDone:
	INC minutes			; incremento di 1 i minuti
  	CPI minutes,60  		; minutes==60 -> Z == 1
  	BREQ hourDone   		; z==1 <-> minutes == 60 -> incremento le ore!
minuteDoneEnding:                 	; this label is useless! but I added it for symmetry to Ovf0Isr block
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
