# expressions
https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_expressions.html


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

# directives 
see https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_directives.html#avrassembler.wb_directives.CSEG
start with a "."
* .org
.org 000000 ; sets the code to start at address 0 (where the reset vector is)
*The ORG directive sets the location counter to an absolute value. The value to set is given as a parameter. If an ORG directive is given within a Data Segment, then it is the SRAM location counter which is set, if the directive is given within a Code Segment, then it is the Program memory counter which is set and if the directive is given within an EEPROM Segment, it is the EEPROM location counter which is set.
The default values of the Code and the EEPROM location counters are zero, and the default value of the SRAM location counter is the address immediately following the end of I/O address space (0x60 for devices without extended I/O, 0x100 or more for devices with extended I/O) when the assembling is started. Note that the SRAM and EEPROM location counters count bytes whereas the Program memory location counter counts words. Also note that some devices lack SRAM and/or EEPROM.*

* .dseg
start data segment
*The DSEG directive defines the start of a Data segment. An assembler source file can consist of several data segments, which are concatenated into a single data segment when assembled. A data segment will normally only consist of BYTE directives (and labels). The Data Segments have their own location counter which is a byte counter. The ORG directive can be used to place the variables at specific locations in the SRAM. The directive does not take any parameters.*

* .cseg
start code segment.
*The DSEG directive defines the start of a Data segment. An assembler source file can consist of several data segments, which are concatenated into a single data segment when assembled. A data segment will normally only consist of BYTE directives (and labels). The Data Segments have their own location counter which is a byte counter. The ORG directive can be used to place the variables at specific locations in the SRAM. The directive does not take any parameters.*



# labels
end with a ":"
### main:
typical label of the main chunk of code. after .org 000000: starts at position 0







