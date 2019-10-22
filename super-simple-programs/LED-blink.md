# intro
should be fairly simple
* use a timer to count seconds. when the timer counter overflows (overflow flag is activated) increase a register until it becomes the desired time. when it does it again, revert. use timer_on and timer_off subroutines
* to light a led, an output pin should be enough
* if needed, use sleep functions to reduce power

# part 1: setting the timer/counter0
1. enable global interrupts. 
* WHERE: main progam init section. by default it's already set.
2. select timer mode, activate overflow flag, speed of tick
* WHERE: main program init section
* HOW: see code

# part 2: what happens on interrupts
1. use ovf0 interrupt vector: timer counter 0 overflow vector, jump to it's subroutine
* where: interrupt vectors, and then in the dedicated subroutines space below
* remember to save the state of the status register (here, in r15)!
2. interrupt subroutine
* if in led_on state, go to led_off, and viceversa
* let's use 1 register to keep track of state: R17 
  * WHERE: in the register definition section: ".def led_state = r17"
* keep interrupts number in a register (R14)!


#  setting output ports
to set the pin0 of portB as output:
    sbi DDRB, DDB0; sbi: sets bit number DDB0 (0) in I/O register DDRB (data direction) -> sets it as OUTPUT
    cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)
    sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if output: HIGH voltage)


# program design
* I need a blink every tot seconds. let's add a constant to be used. 
  * use .equ to define the desired seconds, as ".equ time = 13"
  * WHERE: adjustable constants section!
  * time is the number of interrupts. it depends on the timer mode chosen cases. see "Timer/Counter0 Control Register B"
   * TCCRB: 00000001 -> clk mode 	-> 1 tick / clock cycle(=1micros) -> 1 interrupt/256micros 
     * if time is 1s -> stop mode after 30906.25 interrupts -> too many 
     * to test, stop it after 1 interrupt.
   * TCCRB: 00000101 -> clk/1024 mode: 1tick/1024clock-> 1interr/256 * 1024clock->1interr/262.144ms 
     * if time is 1s -> stop mode after 4 interrupts = 1.048576s! -> stop mode after 4 times the interrupt!
     * NOTE: there's a function that can stop the timer counter before, to get a precise value! but who cares? later!
 * use interrNum (R18) to count interrupts!
 

# code 1: blink every 256micros
```
;
;  ***********************************
; This guy blinks every 256 microseconds
;
;
;
;
;
;
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
;  .equ time = ADD TIME HERE

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

.def interrNum = R18    ; counts number of interrupts. starts at 0.
.def led_state = R17    ; 0 for off, 1 for on
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
  rjmp Ovf0Isr                       ; OVF0 interrupt vector
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
Ovf0Isr:

	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15)
                      ; generic code follows. DO NOT modify rSreg (R15)!
  inc interrNum       ; increments interrupt numbers. when it reaches 4 (in clk/1024 mode) or 1 (in clk mode): switch led state
  CPI interrNum, 1    ; interrNum==1 -> Zflag == 1
  BREQ modeSwitch     ; if 1 interrupt happened: see what mode you are in and switch it
  rjmp Ovf0Isr_end

modeSwitch:           ; led_state==0 -> turn it on; led state==1 -> turn it off;
  LDI interrNum,0     ; clear interrupt number after it counted to the time required
  CPI led_state, 0    ; if not zero: see below -> switch it off
  BREQ switch_it_on
  rjmp switch_it_off


switch_it_on:
  LDI led_state,1
  sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if output: HIGH voltage)
  rjmp Ovf0Isr_end

switch_it_off:
  LDI led_state,0
  cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)
  rjmp Ovf0Isr_end  ; THIS IS USELESS, BUT I LIKE IT HERE BECAUSE OF SYMMETRY REASONS

Ovf0Isr_end:
	out SREG,rSreg			; restore status register from temporary register
	RETI				        ; return from interrupt subroutine

; insert code here

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


; ***** ENABLE GLOBAL INTERRUPTS *****
  sei ; Enable interrupts
;
;
; ***** SET A TIMER *****
; TIMER MODE: see "TCCR0A - Timer/Counter0  Control Register A"
;             default is "normal" -> 0:0 in bites 1:0 -> no operation needed for a simple timer!
;
; ***** ENABLE COUNTER OVERFLOW FLAG *****  -> see manual, 11.9.7
  ldi R16,1<<TOIE0                 ; TOIE0 is the bit1 int TIMSK, timer counter 0 interrupt mask register
  out TIMSK,R16                    ; note whenever it overflows an interruption happens! -> see OVF0 in "interrupt vectors"
;
; ***** TIMER SPEED *****          see "TCCR0B - Timer/Counter0 Control Register B" in the include file to use CS00,CS01,CS02

;testing
ldi R16, 1<<CS00                ; 00000001 -> clk mode 	-> 1 tick / clock cycle(=1micros) -> 1 interrupt/256micros
; use this instead
;ldi R16, (1<<CS00)|(1<<CS02)   ; 00000101 -> clk/1024 mode: 1tick/1024clock->1interr/256*1024clock->1interr/262.144ms

out TCCR0B, R16                  ; sets the bits in the timer control register

; ACTUAL SPEED: 1 interrupt/256micros

; *****CONFIGURE OUTPUT PIN, default it to LOW*****
sbi DDRB, DDB0; sbi: sets bit number DDB0 (0) in I/O register DDRB (data direction register B) -> sets it as OUTPUT
cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)

; *****SET LED MODE, default it to off*****
LDI led_state, 0

; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:
	rjmp loop
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
```

# CODE 2: blink every 1.048s
it should work. try it on a real at tiny, because the simulator is soooo slow!
```
;
; ***********************************
; This guy blinks every 1.048576s
; (1 interrupt every 262.144ms)
;
;
;
;
;
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
;  .equ time = ADD TIME HERE

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

.def interrNum = R18    ; counts number of interrupts. starts at 0.
.def led_state = R17    ; 0 for off, 1 for on
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
  rjmp Ovf0Isr                       ; OVF0 interrupt vector
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
Ovf0Isr:

	in rSreg, SREG			; save status register SREG into temporary register rSreg (R15)
                      ; generic code follows. DO NOT modify rSreg (R15)!
  inc interrNum       ; increments interrupt numbers. when it reaches 4 (in clk/1024 mode) or 1 (in clk mode): switch led state
  CPI interrNum, 4    ; interrNum==4 <-> 1s passed -> Zflag == 1
  BREQ modeSwitch     ; if 1 interrupt happened: see what mode you are in and switch it
  rjmp Ovf0Isr_end

modeSwitch:           ; led_state==0 -> turn it on; led state==1 -> turn it off;
  LDI interrNum,0     ; clear interrupt number after it counted to the time required
  CPI led_state, 0    ; if not zero: see below -> switch it off
  BREQ switch_it_on
  rjmp switch_it_off


switch_it_on:
  LDI led_state,1
  sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if output: HIGH voltage)
  rjmp Ovf0Isr_end

switch_it_off:
  LDI led_state,0
  cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)
  rjmp Ovf0Isr_end  ; THIS IS USELESS, BUT I LIKE IT HERE BECAUSE OF SYMMETRY REASONS

Ovf0Isr_end:
	out SREG,rSreg			; restore status register from temporary register
	RETI				        ; return from interrupt subroutine

; insert code here

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


; ***** ENABLE GLOBAL INTERRUPTS *****
  sei ; Enable interrupts
;
;
; ***** SET A TIMER *****
; TIMER MODE: see "TCCR0A - Timer/Counter0  Control Register A"
;             default is "normal" -> 0:0 in bites 1:0 -> no operation needed for a simple timer!
;
; ***** ENABLE COUNTER OVERFLOW FLAG *****  -> see manual, 11.9.7
  ldi R16,1<<TOIE0                 ; TOIE0 is the bit1 int TIMSK, timer counter 0 interrupt mask register
  out TIMSK,R16                    ; note whenever it overflows an interruption happens! -> see OVF0 in "interrupt vectors"
;
; ***** TIMER SPEED *****          see "TCCR0B - Timer/Counter0 Control Register B" in the include file to use CS00,CS01,CS02

;testing
;ldi R16, 1<<CS00                ; 00000001 -> clk mode 	-> 1 tick / clock cycle(=1micros) -> 1 interrupt/256micros
; use this instead
ldi R16, (1<<CS00)|(1<<CS02)   ; 00000101 -> clk/1024 mode: 1tick/1024clock->1interr/256*1024clock->1interr/262.144ms

out TCCR0B, R16                  ; sets the bits in the timer control register

; ACTUAL SPEED: 1 interrupt/256micros

; *****CONFIGURE OUTPUT PIN, default it to LOW*****
sbi DDRB, DDB0; sbi: sets bit number DDB0 (0) in I/O register DDRB (data direction register B) -> sets it as OUTPUT
cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)

; *****SET LED MODE, default it to off*****
LDI led_state, 0

; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:
	rjmp loop
;
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2019 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)10 9ybG reahdrS hcimtd  " ; Machine code format
;  
```



