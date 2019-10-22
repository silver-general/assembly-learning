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

# program design
* I need a blink every tot seconds. let's add a constant to be used. 
  * use .equ to define the desired seconds, as ".equ time = 13"
  * WHERE: adjustable constants section!
  * time is the number of interrupts. it depends on the timer mode chosen cases:
   * 
   * 
   * 
