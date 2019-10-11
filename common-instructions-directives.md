
# misc
* *$*, or *0x*   is used to indicate hexadecimal values. same as 0x!
* ...

# REGISTERS OPERATIONS
some registers are general purpose, others are input/output (of those, some are control registers)
1. how do I change/set registers?
2. when do I use MOV, IN, OUT, LDI, et cetera??

# expressions
https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_expressions.html

# IF STATEMENTS
"If a value is equal to a constand, do this"
```
CPI R18,0 ; compares and stores either 0 or 1 into the boolean register (WHERE???)
BREQ else ; jump conditionally to the else block, somewhere in the near

; ... other code, the THEN block

else: 
  ;this is the code you jump to
```

# instructions 
see https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html

### RJUMP
https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_RJMP.html
Relative jump to an address within PC - 2K +1 and PC + 2K (words)
2Kbytes: 2000 bytes, quindi se una cella della program memory è 1 byte: -1999,+2000          SICURO???????????????????

read this! https://www.avrfreaks.net/forum/rjmp-labels-and-pc-%E2%86%90-pc-k-1

EG:
target:
  RJMP target

### SBR- Set Bits in Register 
ORI OR, immediate between 2 operators.


# directives 
see https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_directives.html#avrassembler.wb_directives.CSEG
start with a "."

### .ecu *name* *constant*
equicalent to #def in C. assigns a constant to a name. it can't be modified!

### .org

*The ORG directive sets the location counter to an absolute value. The value to set is given as a parameter.* 

* *If an ORG directive is given within a Data Segment (after ".DSEG" command), then it is the SRAM location counter which is set;
* *if the directive is given within a Code Segment (after ".CSEG" command), then it is the Program memory counter which is set;
* *if the directive is given within an EEPROM Segment (after "???" command), it is the EEPROM location counter which is set;

* The default values of the Code and the EEPROM location counters are zero, and the default value of the SRAM location counter is the address immediately following the end of I/O address space (0x60 for devices without extended I/O, 0x100 or more for devices with extended I/O) when the assembling is started. Note that the SRAM and EEPROM location counters count bytes whereas the Program memory location counter counts words. Also note that some devices lack SRAM and/or EEPROM.*

Syntax:
.ORG expression

Example:
```
.DSEG ; Start data segment

.ORG 0x120 ; Set SRAM address to hex 120
variable: .BYTE 1 ; Reserve a byte at SRAM adr. 0x120

.CSEG
.ORG 0x10 ; Set Program Counter to hex 10
mov r0,r1 ; Do something
```

### .dseg
start data segment
*The DSEG directive defines the start of a Data segment. An assembler source file can consist of several data segments, which are concatenated into a single data segment when assembled. A data segment will normally only consist of BYTE directives (and labels). The Data Segments have their own location counter which is a byte counter. The ORG directive can be used to place the variables at specific locations in the SRAM. The directive does not take any parameters.*

### .cseg
start code segment.
*The DSEG directive defines the start of a Data segment. An assembler source file can consist of several data segments, which are concatenated into a single data segment when assembled. A data segment will normally only consist of BYTE directives (and labels). The Data Segments have their own location counter which is a byte counter. The ORG directive can be used to place the variables at specific locations in the SRAM. The directive does not take any parameters.*

### .set ........................................................


# labels
end with a ":"
### main:
typical label of the main chunk of code. after .org 000000: starts at position 0







