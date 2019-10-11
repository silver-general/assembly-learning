# intro

* a switch pressed by the user, a data read on the UART (serial port), a
sample taken by the ADC, or a timer calling to say that "time is up!". All these
events neeeds to be handled by the MCU.

* *interrupts* are a good alternative to *polling*. instead of cheching for news, you just get interrupted.

* *interrupts* are *subroutines*: they interrupts the program and then it resumes later

## a note on names
*names* are used to represent actual *memory locations* and are defined in the* *def.inc* file, the files that includes all the names for a particular microcontroller. see the *def* file for ATtiny85.
  * EG ``` .equ	MCUCR	= 0x35     ; MCU Control Register -> control bits for power management ```

# theory
* **use SEI to set global interrupt enabler in the I-bit (7th bit) in the control register!** 
* interrupts are handled by *interrupt vectors*. those are pointers to certain code memory cells that are referenced when a certain interrupt happens.
* the block of cells of program memory (in the flash ROM, starting at 0x0000) is the *program memory vector table*, dedicated to the reset vector and several interrupt vectors.
* **note**: in the default template of a sim-avr .asm file you can see those vectors defined (.org directive) by default.

* **priority**: the lower the address, the higher the priority (RESET has the highest)
* when an interrupt occurs, the *global interrupt enable bit1* is cleared, and interrupts are disable. if the user want to nest interrupts he must reset the bit to 1. when an interrupts ends and a *return from an interrupt* is executed (RETI), the *global interrupt enable bit1* is set to 1 again.

## 2 types of interrupt:
1. triggered by an event that sets the *interrupt flag* in the *status register*. the *interrupt flag* is set with SEI (set global interrupt flag), cleared with CLI (clear global interrupt flag)
 * when using CLI, all interrupts are disabled, even if they occure when CLI is being executed.
* program counter is vectored to the corresponding interrupt vector
* hardware clears the corresponding flag, OR you can clear it by writing a logic 1 (not a zero?) ---------------------> ???
If an interrupt condition occurs while the corresponding interrupt enable bit is cleared, the Interrupt Flag will be set and remembered until the interrupt is enabled, or the
flag is cleared by software. Similarly, if one or more interrupt conditions occur while the Global Interrupt Enable bit
is cleared, the corresponding Interrupt Flag(s) will be set and remembered until the Global Interrupt Enable bit is
set, and will then be executed by order of priority.
WHAAAAAAAAT----------------------------------------------------------------------------->>>>> ????????????????????
2. second type will trigger as long as there is the *interrupt condition* (what is it????????). These interrupts do not necessarily have Interrupt Flags. If the interrupt condition disappears before the interrupt is enabled, the interrupt will
not be triggered.------------??????????????????????????

* **Note:** that the Status Register is not automatically stored when entering an interrupt routine, nor restored when
returning from an interrupt routine. This must be handled by software. 
* **Note:** the return address must be saved in the stack (SRAM) to remember where to return after a subroutine!

# interrupt response time
* in AVR, minimum 4 clock cycle.
 * program counter pushed unto the stack (1 cycle), vector jumps to the interrupt routine (3 cycles)
 * multi-cycle instruction interrupted: the instruction is completed, then it interrupts
 * device in sleep mode: increases 4 cycles (to wake it up)
* return from an interrupt: 4 cycles

# defining interrupts vectors
* .org directive: sets vector jump locations to an **absolute** value. it is **not** part of the AVR instruction set, it's a command for the assembler!


EXAMPLE
```
; Interrupt service vectors
; Handles reset and external interrupt vectors INT0 and INT1
.org $0000
rjmp Reset ; Reset vector (when the MCU is reset)
.org INT0addr
rjmp IntV0 ; INT0 vector (ext. interrupt from pin PD2)
.org INT1addr
rjmp IntV1 ; INT1 vector (ext. interrupt from pin PD3)
; - Reset vector - (THIS LINE IS A COMMENT)
Reset:
ldi TEMP,low(RAMEND) ; Set initial stack ptr location at ram
end
out SPL,TEMP
ldi TEMP, high(RAMEND)
out SPH, TEMP
...
...
```

# structure of an interrupt driven program
