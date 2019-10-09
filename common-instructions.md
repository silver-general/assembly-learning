# directives
* .ORG 0x0000 ; address. sets the reset vector?


# instructions 

### RJUMP
https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_RJMP.html
Relative jump to an address within PC - 2K +1 and PC + 2K (words)
2Kbytes: 2000 bytes, quindi se una cella della program memory è 1 byte: -1999,+2000          SICURO???????????????????

read this! https://www.avrfreaks.net/forum/rjmp-labels-and-pc-%E2%86%90-pc-k-1

EG:
target:
  RJMP target
