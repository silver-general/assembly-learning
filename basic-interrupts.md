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
* interrupts are handled by *interrupt vectors*. those are pointers to certain code memory cells that are referenced when a certain interrupt happens.
* the block of cells of program memory (in the flash ROM, starting at 0x0000) is the *program memory vector table*, dedicated to the reset vector and several interrupt vectors.
* **note**: in the default template of a sim-avr .asm file you can see those vectors defined (.org directive) by default.

* **priority**: the lower the address, the higher the priority (RESET has the highest)
* when an interrupt occurs, the *global interrupt enable bit1* is cleared, and interrupts are disable. if the user want to nest interrupts he must reset the bit to 1. when an interrupts ends and a *return from an interrupt* is executed (RETI), the *global interrupt enable bit1* is set to 1 again.

* **2 types of interrupt**:
1. triggered by an event that sets the *interrupt flag* in the *status register*. the *interrupt flag* is set with SEI (set global interrupt flag), cleared with CLI (clear global interrupt flag)

# structure of an interrupt driven program
