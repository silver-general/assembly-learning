1. [continua](#continua)

short intro at https://exploreembedded.com/wiki/AVR_Timer_programming

good explanation at http://www.avr-asm-tutorial.net/avr_en/starter/starter.html

# QUESTIONS: 
1. why stack pointer can't address position higher than 0x60?
2. in the program template it only loads stack pointer low, but the ATtiny has 512bytes of SRAM, so it needs the high bits! why is that?
3. where in the guide should I put the stack operation part?
4. how big is the stack? as big as the remaining SRAM? 
5. push and pop seem not to send data to the stack. what?????????????????????????????????????????????


# intro

timer/counter is an independent unit inside the MCU. it's used for:
* **internal timer**: the timer ticks at its oscillator frequency (that can be scaled)
* **external counter**: it is used to count events in a specific internal pin
* **PWM**

# 8 bit timer/counter0
## features
* 2 independent output compare units
* double buffered output compare registers
* clear timer on compare match (auto reload)
* glitch free,phase correct PWM
* variable PWM period
* frequency generator
* three independent interrupt sources (TOV0, OCF0A, OCF0B)

## basics
* 8 bit -> can count 0-255
* the register that stores the count is TCNT0 (see the include.files for it's definition)
* if TCNT0 overflows, a TimerOverflowFlag (TOV) is set -> IF the overflow interrupt is enabled (in TIMSK, timer counter mask register), a timer overflow INTERRUPT happens!
* if you put a value into the Output Compare Register (OCR0), whenever the counter reaches it, it sets the Output Compare Flag (OCF0)

given the timer/counter control register 0 (TCCR0):
the bits are: D7,D6,D,D4,D3,D2,D1,D0
* set clock frequency: D2,D1,D0. 000=no timer; 001=cloak; ... see documentation 
  * note: this starts the timer!
* set timer mode: see documentation D6,D3 ... see documentation. default: 0 to 255

# how to set a timer

* the **count** is taken in the 8bit register Timer Counter 0: **"TCNT0"**
* the **timer settings** are selected through the bits in Timer Counter Control Register: 
  * **frequency** of clock in **TCCR0B**: bits 2,1,0 -> 000:no timer; 001: clock speed; ... see documentation
  * **timer mode** in **TCCR0A**: bits 1,0 -> default (0,0): normal. 0 to 255; ... see documentation

* count will be stored in TCNT0
* whenever it overflows a TimerOverflowFlag (TOV) is set -> HOW?????????????????


#### let's set a timer, normal mode, at clk/1024
* normal mode: set bits 1,0 of TCCR0A to 0,0 -> it's the default, no action required.
* activate timer at clk/1024: set bits 2,1,0 of TCCR0B to 1,0,1 -> what command? see below
 * to get the inactive timer: set bit 2:1:0 of TCCR0B to 0:0:0 -> clr R16 \n out TCCR0B,R16 ; loads all zeroes 
 * to get the clock speed: set bit 2:1:0 of TCCR0B to 0:0:1 -> ldi R16, 1<<CS00 ;(CS00 is 0) \n out TCCR0B,R16 ; sets first bit to 1
 * to get clk/1024:  set bit 2:1:0 of TCCR0B to 1:0:1 -> ldi
 
```
; TIMER MODE: see "TCCR0A - Timer/Counter  Control Register A"
; default is "normal" -> 0:0 in bites 1:0 -> no operation needed for a simple timer!

; ENABLE COUNTER OVERFLOW FLAG   -> see manual, 11.9.7
ldi R16,1<<TOIE0                 ; TOIE0 is the bit1 int TIMSK, timer counter interrupt mask register    
out TIMSK,R16                    ; 

; TIMER SPEED: see "TCCR0B - Timer/Counter Control Register B" in the include file to use CS00,CS01,...
; CHOOSE 1, COMMENT THE OTHERS:
clr R16                          ; 00000000 -> no timer
ldi R16, 1<<CS00                 ; 00000001 -> clk mode 
ldi R16, (1<<CS00)|(1<<CS02)     ; 00000101 -> clk/1024 mode

out TCCR0B, R16                  ; sets the bits in the timer control register
```

## when the timer overflows
* TIFR, timer/counter interrupt flag register sets the bit1, TOV0, to 1. 
 * it is then restored to 0 during the interrupt sequence, or by software.
* in order to have an interrupt, you must **first enable the timer counter overflow interrupt enabler, see 11.9.7**
 * in TIMSK register, set bit1 (TOIE0) to 1

* when an interrupt condition occurs, the CPU does the following:
1. switches off further interrupts by clearing the I-bit (7th bit, global interrupt enabler) in the status register 
2. saves the current execution address counter on a **stack** (SRAM) to be resumed later
3. tells the program counter the next address, so it jumps to the location specific for that interrupt
4. at that location another jump to a subroutine
5. RETI instruction is executed
5.1 retrieves the previous execution address and gives it to the program counter
5.2 set to 1 the global interrupt enabler I-bit (7th bit) in the status register

## what's a STACK? -> see documentation par 4.6
a stack is a chunk of memory in the SRAM. see **"data memory declaration" in the include file!**
* at initialization **(main program init)** we must declare that at the end of SRAM storage a port register named Stack Pointer (SP) points there.
* if the device has less than 256-96=160 bytes of SRAM, the StackPointer is a single point register SPL (stack point low bytes)
* if it has more, there is also the high bits of the stack pointer in another register, SPH

#### initialize a stack
```
  ldi R16,HIGH(RAMEND) ; Load the MSB of the last SRAM address to R16 ; only if device has more than 256-96=160 SRAM bytes!
  out SPH,R16 ; and write it to the MSB of the stackpointer high          ; only if device has more than 256-96=160 SRAM bytes!
  ldi R16,LOW(RAMEND) ; Load the last SRAM address to R16     
  out SPL,R16 ; and write it to the LSB of the stackpointer low  
  
; once you write an address to SPH,SPL, the stackpointer points there!
```


#### stack operations
1. push a value on top of the stack (decreases the stack pointer address)
```
  ldi R16,'A'                         ; loads immediately ASCII character A to R16
  push R16 ;                          ; decreases stack pointer address, adds a value there (on top of stack)
  pop R0 ;                            ; moves current stack entry intro the register specified, increments StackPointer
```



# timer interrupt vectors
in AVR-sim create a file not comprehensive, interrupts enabled.
```
; ***********************************
; DIRECTIVES
; ***********************************
.nolist
.include "tn85def.inc" ; Define device ATtiny85
.list
;
.cseg
.org 000000

; **********************************
;       R E G I S T E R S -------------> note this is not in the "not comprehensive" file, I added it later, see below
; **********************************
;
; free: R0 to R14
.def rSreg = R15   ; storage register for status register (store it here during interrupts)
; **********************************
; R E S E T  &  I N T - V E C T O R S    -> here are places where you arrive when interrupts happen, and whence you jump 
; **********************************
	rjmp Main ; Reset vector
	reti ; INT0
	reti ; PCI0
	reti ; OC1A
	reti ; OVF1
	rjmp Ovf0Isr ; OVF0
	reti ; ERDY
	reti ; ACI
	reti ; ADCC
	reti ; OC1B
	reti ; OC0A
	reti ; OC0B
	reti ; WDT
	reti ; USI_START
	reti ; USI_OVF
; **********************************
;  I N T - S E R V I C E   R O U T .       ; here are the INTERRUPT subroutines, you jump here from the jump vector list!
; **********************************
Ovf0Isr:				           ; subroutine in case of timer0 overflow
  in rSreg,SREG 		     ; Save the SREG (status register) in sSreg (temporary register, set to R15 in "registers" section)
  
  ; ... further code
  
  out SREG,rSreg                     ; Restore the SREG. puts rSreg into SREG	
  reti ; Return from interrupt
; **********************************
;  M A I N   P R O G R A M   I N I T
; **********************************
Main:
.ifdef SPH ; if SPH is defined
  ldi rmp,High(RAMEND)
  out SPH,rmp ; Init MSB stack pointer
  .endif
	ldi rmp,Low(RAMEND)
	out SPL,rmp ; Init LSB stack pointer
; ...
	sei ; Enable interrupts
; **********************************
;    P R O G R A M   L O O P
; **********************************
Loop:
	rjmp loop
;
; End of source code
                                                          
```
1. by default, all interrupts are defined with a RETI intruction in them, so they return to normal if accidentally enabled
2. OVF1, OVF0 sono gli overflow dei 2 counter dell'ATtiny 
3. take the line OVF0 and write a jump to Timer0 Overflow Subroutine: **Ovf0Isr**, che poi scrivi nella sezione *INT - SERVICE ROUT* (interrupt service routine, right under the interrupt vector list)


#### preserving data
* register can change during an interrupt -> save in stack OR use exclusively the resources to each interrupt.
* save status register somewhere. by tradition, it's R15. let's call it *sReg* and define it under *registers* (let's define it above)
```
; "I N T - S E R V I C E   R O U T" section
Ovf0Isr:				           ; subroutine in case of timer0 overflow
  in rSreg,SREG 		     ; Save the SREG (status register) in sSreg (temporary register, set to R15 in "registers" section)
  ; ......... further code
  out SREG,rSreg                     ; Restore the SREG. puts rSreg into SREG	
  reti ; Return from interrupt
```

# SECTION 2: DATE AND TIME
how many second is a tick of timer, if I tick every 1024 clock cycles?
* if I get 1M ticks/second, I have 1ns/tick. 1024 ticks last 1024ns=1.024ms. to count to a second, I need 976.5625 ticks 

let's use 3 bytes as consecutive registers R14,R13,R12.

# continua

