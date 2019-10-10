short intro at https://exploreembedded.com/wiki/AVR_Timer_programming

good explanation at http://www.avr-asm-tutorial.net/avr_en/starter/starter.html
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
* if TCNT0 overflows, a TimerOverflowFlag (TOV) is set -> HOW??????????????????????????????????????????????????????
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

; TIMER SPEED: see "TCCR0B - Timer/Counter Control Register B" in the include file to use CS00,CS01,...
; CHOOSE 1, COMMENT THE OTHERS:
clr R16                          ; 00000000 -> no timer
ldi R16, 1<<CS00                 ; 00000001 -> clk mode
ldi R16, (1<<CS00)|(1<<CS02)     ; 00000101 -> clk/1024 mode

out TCCR0B, R16                  ; sets the bits in the control register
```

#### when the timer overflows

