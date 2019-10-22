# references

is this guide good?
https://brauniusengineering.com/attiny85-with-arduino-mega/

https://www.instructables.com/id/Program-an-ATtiny-with-Arduino/

https://medium.com/jungletronics/attiny85-easy-flashing-through-arduino-b5f896c48189

this uses tha arduino uno, but should be conceptually identical
https://www.instructables.com/id/How-to-Program-an-Attiny85-From-an-Arduino-Uno/

# intro
as I should have understood, I need to upload a sketch to the arduino and then connect the pins as shown in the guides

schematics of pins? see One Note (I'll add it here later)


# steps

## arduino ide setting
get the attiny support in the arduino ide
* file - board - settings - Additional Boards Manager URLS
  * add "https://raw.githubusercontent.com/damellis/attiny/ide-1.6.x-boards-manager/package_damellis_attiny_index.json"
* go to tool - boards - boards manager. attiny should be listed. install it
  * attiny is now in the board menu
  
* get the programming sketch: file - examples - arduinoISP

you must modify the sketch to match the correct pins
* change the #define RESET form pin 10 to pin 53 (since that is the reset pin on a arduino mega
* change below: #define PIN_MOSI	51//was 11; #define PIN_MISO	50//was 12; #define PIN_SCK		52//was 13
* upload it

## using arduino as the programmer
* add a capacitor between arduino reset and ground: this "turns off" the arduino, so it doesn't take the code for himself.
Now we have to connect the pins from the Arduino mega to the ATtiny.
        
        Mega Pin 51 to ATtiny Pin 5 (MOSI)
        Mega Pin 50 to ATtiny Pin 6 (MISO)
        Mega Pin 52 to ATtiny Pin 7 (SCK)
        ATtiny pin 4 GND (Ground pin)
        ATtiny Pin 8 to VCC (5V)
        Mega Pin 53 to ATtiny Pin 1 (SS)

* set up attiny85 in boards
* upload sketch

**this works, but I can't upload assembler code into the attiny! I need to learn avrdude**

# AVRDUDE
https://www.ladyada.net/learn/avr/avrdude.html

command line. type "avrdude". options happen. most important
* -p <partno>: This is just to tell it what microcontroller its programming. For example, if you are programming an ATtiny2313, use attiny2313 as the partnumber
* -c <programmer>: Here is where we specify the programmer type, if you're using an STK500 use stk500, if you're using a DT006 programmer use dt006, etc. 
* -P <port>: This is the communication port to use to talk to the programmer. It might be COM1 for serial or LPT1 for parallel or USB for, well, USB. 
* -U <memtype>:r|w|v:<filename>[:format]: OK this one is the important command. Its the one that actually does the programming. 
 * <memtype> is either flash or eeprom (or hfuse, lfuse or efuse for the chip configuration fuses, but we aren't going to mess with those). 
 * the r|w|v means you can use r (read) w (write) or v (verify) as the command. 
 * The <filename> is, well, the file that you want to write to or read from. and [:format] means theres an optional format flag. We will always be using "Intel Hex" format, so use i

* So, for example. If you wanted to write the file test.hex to the flash memory, you would use -U flash:w:test.hex:i. If you wanted to read the eeprom memory into the file "eedump.hex" you would use -U eeprom:r:eedump.hex:i
 
* -c <programmer>: 
To get a list of supported programmers, type in avrdude -c asdf (asdf is just some nonsense to get it to spit out the list of programmers) Here is my output, yours may vary a little. Don't bother memorizing it, just glance through the list.

C:\>avrdude -c asdf
**in the list, a valid programmer is "arduino"!**

NOTE: use the name of arduino!

* -p <partno>: 
To get a list of parts supported by avrdude, type in avrdude -c avrisp (** it doesnt matter if you're not useing an avrisp programmer** ) without a part number into the command line. Don't memorize this list, just glance over it to get an idea of the chips that are supported.
****
C:\>avrdude -c avrisp
avrdude: No AVR part has been specified, use "-p Part"
