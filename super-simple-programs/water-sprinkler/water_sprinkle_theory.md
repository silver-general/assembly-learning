1. [to do](to-do)

## questions
1. do I need the global interrupt enabler?
2. how do I implement sleep as a subroutine (to call it as a function)?

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
ldi R16, 1<<CS00                  ; 00000001 -> clk mode -> 1 tick / clock cycle. 10^6s=1ns for 1 clock cycle
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
Once you are in the timer0 overflow subroutine, you must sign somewhere that about 1024ns + the nanoseconds prior the timer settings ( that you can ignore because it's very little time) have passed -> use a couple of register depending on how much info you need.

Let's say I can tick every 1.024ms=1024ns -> 976.5625 tick/s 
1. I take 976.565 tick/s -> 58593.9 ticks/min -> 3515634 ticks/h -> no need to go beyond. I need 12/24 hours.
2. I take 977.000 ticks/s (error of 0.0004%) -> no need, because in an hour there are no decimals already!

every tick is an overflow, therefore I need to increment a value in a register (or 2). 
1. 12h -> 42187608 ticks -> store it in 19.68... = 20 bit 
2. 24h -> 84375216 ticks -> ... = 20.68... = 21 bit
3: therefore, 24 bits are required -> 3 bytes! **I need 3 registers**

## to do:
how do I store a number in multiple registers? -> let's find out, but later.					

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
	out SREG,rSreg			; restore status register from temporary register
	RETI				; return from interrupt subroutine
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
