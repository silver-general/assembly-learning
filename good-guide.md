http://www.avr-asm-tutorial.net/avr_en/starter/starter.html

# 2 CPU
## 2.1 CPU in general
1. program counter: points to the program memory (where instructions are) and counts up (or is redirected) to the next instruction. in AVR, instructions are 16 bits. 
in AVR, the program memory is in the ROM (flash), each cell is 1byte, each instruction 2bytes.
note: program counter can point to SRAM or EEPROM!
2. the fetched instruction is decoded in the... 
3. execution of the instruction (and fetching of next instruction, if pipelining)
4. repeat
## 2.2 AVR specifics
* 32 registers, 8bit each.
