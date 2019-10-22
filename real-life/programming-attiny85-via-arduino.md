# references

is this guide good?
https://brauniusengineering.com/attiny85-with-arduino-mega/

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

