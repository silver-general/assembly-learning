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

