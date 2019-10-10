## power saving modes
https://microchipdeveloper.com/8avr:avrsleep

1. Idle Mode
2. Power Down
3. Power Save
4. Standby
5. Extended Standby

## enter sleep mode
https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_SLEEP.html

* to enter sleep mode: set to 1 the sleep enable bit in the *sleep mode control register* (SMCR.SE)
-> should I use SBR, Set Bits in Register ?

* the register is the MCUCR, but what register is it? how do I access it?
-> in the documentation, par 7.5.1, MCUCR is at address 0x35, the bit to enable in bit 5

## to make it sleep

1. set the bit 5 of MCUCR (MCU control register) to 1. how? -> http://rjhcoding.com/avr-asm-io.php
* put the value 1<<SE (1 shifted by 5, SE: sleep enable, 5th bit of MCUCR) into a register, R16 (can I use others?)
* load the register into MCUCR with "out": stored a register into an I/O register, or control register
2. sleep
```
; set bit 5 of MCUCR (microcontroller unit control register) to 1.
; MCUCR is located at 0x35, and in the definitions MCUCR is already the variable for that. use MCUCR instead of 0x35!

; Copy r11 to r0
mov r0,r11 

; Enable sleep mode: load immediately r16 (a general purpose register) with 1 shifted by 5 (SE: sleep enable, bit 5 of MCUCR, control register!)
ldi r16,(1<<SE)   

; OUT - Store Register to I/O Location -> stores R16 (contains 00010000) into MCUCR (to set bit 5, sleep enable, to 1)
out MCUCR, r16        

sleep ; Put MCU in sleep mode
```

# QUESTIONS
1. why in the example

; Copy r11 to r0
mov r0,r11 

??
