# what does it do?
it's a little system that activates a tiny water pump (DC motor with some plastic around) every 24 hours.

# components
* mini water pump
* generic electronics: battery, transistor to use as switch ----------------------> any other choice?
* microcontroller: ATtiny85 

# CODE
the ATtiny85 has to go on low power, activate every 24h, and back to sleep


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
