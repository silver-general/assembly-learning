# hardware overview
see official schematics for details and pictures

_ _ _ _ _ _ _ _

OFFICIAL DATASHEET: ATtiny85

* RISC architecture, CMOS 8 bit

* in-system programmable FLASH : 8kbyte -> acts as program memory!
* EEPROM : 512 bytes
* SRAM : 256 bytes -> contains the STACK! -> 5 different addressing modes

* general purpose I/O lines : 6 of them
* 32 general purpose registers 
* one 8bit timer/counter with compare mode
* one 8bit high-speed timer/counter
* universal serial interface
* internal and external interrupts
* ADC, 4 channel, 10 bit (analog to digital converter)
* programmable watchdog timer with internal oscillator

* 3 power saving modes:
  * idle: stops CPU, keeps active: SRAM, timer/counter,ADC,analog comparator,Interrupt System
  * power down: saves registers content, until next Interrupt, Software reset
  * ADC noise reduction: stops CPU and all I/O modes, except for ADC to minimize noise
  

# ARCHITECTURE

* Harvard: different memory places for program and data
* PROGRAM MEMORY is the in-system reprogrammable Flash memory. instruction from program memory are executed with a single level pipelining
* register file: 32 8bit registers, single clock access time -> single cycle ALU operations:
  2 values from register file, operation done and result stored in register file in a clock cycle!
  6 registers (X,Y,Z) can be used 2 at a time to store 16 bit addresses to the FLASH program memory.
* ALU: performs operations between 2 register, 1 register, 1 register and a constant (can be read by ..?..)
* status register is updated at the end of the operation to reflect info about the operation (eg comparison)

* intruction are 16 bits, but they can be 32 (see Evernote notes - to be added later!) !!!!!! <<<<<<<--------
* interruptions and subroutines: the program counter address is saved in the STACK, later to be retrieved
  -> the stack is a chunk of memory in SRAM!
* memory spaces are regular memory map. SEE https://en.wikipedia.org/wiki/Memory-mapped_I/O -> "Memory-mapped I/O uses the same address space to address both memory and I/O devices."

*flexible interrupt module has its control registers in the I/O space, with an additional Global Interrupt Enable bit in the status register
  all interrupts have their interrupt vector in the interrupt vector table
  interrupts have a priority in accordance to their position in the interrupt vector table -> lower the address, higher the priority
* I/O memory space has 64 addresses for CPU peripherals functions 
  I/O moemory can be accessed directly, or as the Data Space locations following those of the Register File, 0x20 - 0x5F.

4.3 ALU
* operations: arithmetic, logic, bit-function. see "instruction set" for more
* operations done in a clock cycle

4.4 STATUS REGISTER
* SR is not saved if an interruption occurs! it must be handled by the software!
* see 4.4.1 for details about the bits of status register. 
  * I: global interrupt enable: seasrch "interruption in AVR microprocessors"
  * T: bit copy storage: a bit from a register can be stored/retrieved from/to a register via BST(bit store) and BLD(bit load)
  * H: half carry flag: used diring half carry in arithmetics
  * S: bit sign: see instruction set description
  * V: 2's complement overflow tag
  * N: negative flag
  * Z: zero flag
  * C: carry flag
  
4.5 GENERAL PURPOSE REGISTER
* location: first 32 addresses of the data space
* each cell: 8bits

* I/O possibilities:
  * one 8bit output operand, one 8bit input result operand
  * two 8bit output operand, one 8bit input result operand
  * two 8bit output operand, one 16bit input result operand
  * one 16bit output operand, one 16bit input result operand
  
* see evernote notes for exceptions and stuff like x,y,z registers (to be added later!!) ------>>>> !!!!

4.6 STACK POINTER
* the stack pointer register has address of the top of the stack, in the SRAM! MUST be always above 0x60
* the stack grows from higher to lower addresses -> PUSH puts something on top -> DECREASES the address!
* SP is implemented as two 8 bit registers in the I/O space: SPL and SPH (low and high bits)

4.7 INSTRUCTION EXECUTION TIMING
* pipelining, 2 levels

4.8 RESET AND INTERRUPT
4.8.1

- - - - -

5 AVR MEMORIES
* DATA memory, Program memory, EEPROM for data storage.

5.1 in-system re-programmable Flash program memory
...


_ _ _ _ _ _ _ _ _ _
_ _ _ _ _ _ _ _ _ _




# ... WHAT HAPPENS ON EXECUTION

1. when power to the chip rises, a reset sequence is triggered.
   the program counter is set to address zero (the first in program memory on the flash). first instruction is here.
   the program counter points to position 0 also when:
   - external reset on reset pin is triggered (by setting it to...???)
   - watchdog counter reaches its maximum value. the watchdog is reset from time to time by the software. if not, it resets the chip. how often?????
       when the power supply rises, a reset sequence is triggered 
   - you jump to the reset address (NOTE: not a real reset, register values are not set to defaults!) 
   - you can specify another starting point with a directive before the code. useless now.

   - the address 0 is also called the reset vector. the following addresses are interrupt vectors. you should read more at "handling interruptions" 

2. an instruction is fetched to the INSTRUCTION REGISTER? and while executed, the program counter is incremented and the following instruction is fetched (2 level pipeline) 

NOTE: program execution is linear, unless branches happen 




# ... TIMING DURING EXECUTION 

* one instruction is executed per clock cycle (exceptions: branching operations, SRAM read/write) 
* 8MHz clock -> one clock cycle every 125ns  
* to delay executions, use the most useless instruction: 
    NOP ; no operation. wastes one clock cycle. use it in a loop 
    
    
    
# REGISTERS 

* 8 bit storage spaces 

* source and target for calculations, connected directly to cpu 

* 32 in total, they have rules. see: register exceptions and stuff. 

* POINTER REGISTERS: X,Y,Z : used to address with 16 bits the SRAM or (only Z) the program memory in the Flash memory. see: ONE NOTE NOTES




# REGISTER OPERATIONS 

* load a constant
  LDI R16, 150 ; loads 150 into register R16 
  - nota: can be done on registers R16-R31! use MOV to change R0-R15? 

* copy a value between 2 registers
  MOV R15, R16 ; copia R16 in R15 

* CLR R15 ; mette tutto a 0 
    note: can be done on ANY register! 
* increment by one
  INC R1 ; increments R1 by 1 
  - note: in case of overflow, the result is 1 and the zero bit i  the status register is set to 1. the carry bit in the status register is NOT changed! 

NOTE: several other comamnds are valid only for R16-R32: see datasheets 

 

 

# DIRECTIVES 

* tell the assembler stuff, like "I'll use this name instead of R12" 

1. set new names for registers
.DEF newname = R0 ; sets a new name for register R0 

2. create macros for text to be replaced    

.MACRO delay1 
NOP; no operation 
NOP 
NOP 
.ENDMACRO ; note: it is all written multiple times in program memory. to save space, use subroutines 

3. subroutines: instructions grouped into "functions" 

delay1: 
NOP 
NOP 
RET 
 ;and then call it as: 
RCALL delay1 ; note: must set the stack pointer first, see instructions 



# LABELS 

* labels are the pointers to a chunk of code. how big can they be? 
* defining a label: use the ":"->  "start:" 
