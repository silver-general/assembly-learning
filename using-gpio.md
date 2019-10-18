# intro

read-modify-write:
* all GPIO pins can be set to IN or OUT.
* you can change drive value ???
* you can enable/disable pullup resistors. those are supply-voltage invariant resistances!

* there are protection diodes to ground and to Vcc
* nomenclature: PORTxn -> port x, bit n. EG PORTB3: bit 3 of port B

* 3 memory addresses for each port:
  * data register **PORTx** (read/write)
  * data direction register **DDRx** (read/write)
  * port input pins **PINx** (read only, BUT: writing a logic one to a bit in the PINx register toggles the corresponding bit in the data register PORTx!
  * to disable all pullup resistors: set the pullup disable bit (**PUD**) in **MCUCR** (microcontroller unit control register)
  
* some port pins have **alternative functions**

# ports as general digital I/O
## configuring a port Pin
* each port has 3 register bits
  * DDxn in the DDRx register: data direction, i.e. the flow of data. logic one: output
  * PORTxn in PORTx register (data register): 
  * PINxn : 
* IF pin is configured as input pin and PORTxn is set to one -> pullup resistor is activated
* to switch off the pullup resistor: 
  * configure pin as output

* when the pin is configured as OUT:
  * PORTxn to 1: outs an HIGH
  * PORTxn to 0: outs a LOW
## 10.2.3 <. read this!
...

# part 2: attiny85 in particular
* 6 GPIO pins
* only portB is present in the include files. why no portA?????????????
* every port has 3 8-bit registers associated
* data direction register: DDRA,DDRB,...
  * eg: make all pins of port A as input: put 0b00000000 in DDRA
  * eg: as output: DDRA=0b11111111
  * eg: lower nibble input, higher nibble output: put 0b11110000 in DDRA
  
## useful addresses
* PORTB : port B data register. 
* DDRB data direction register. 8 bit, 5:0 bits are used (for the 6 input pins)
* pinB port b input pin address

1. set a pin as input or output: set or clear their bit in the DDRB
```
cbi DDRB,DDB0 ; clears data direction register bit 0 -> input
sbi DDRB, DDB0 ; sets data direction register bit 1 -> output
```
2. 

### code chunks
* cbi DDRB,DDB0 ; cbi: clears bit number DDB0 (0) in I/O register DDRB (data direction) -> sets it as INPUT
* sbi DDRB, DDB0; sbi: sets bit number DDB0 (0) in I/O register DDRB (data direction) -> sets it as OUTPUT
* cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if input: disable pullup resistor; if output: LOW voltage)
* sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if input: enable pullup res.; if output: HIGH voltage)

### recap
* to set the pin0 of portB as input:
  * cbi DDRB,DDB0 ; cbi: clears bit number DDB0 (0) in I/O register DDRB (data direction) -> sets it as INPUT
  * cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if input: disable pullup resistor)
  * sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if input: enable pullup resistor)
* to set the pin0 of portB as output:
  * sbi DDRB, DDB0; sbi: sets bit number DDB0 (0) in I/O register DDRB (data direction) -> sets it as OUTPUT
  * cbi PORTB, PORTB0 ; clears bit number portb0 (0) in register PORTB (if output: LOW voltage)
  * sbi PORTB, PORTB0 ; sets bit number portb0 (0) in register PORTB (if output: HIGH voltage)
