# WHAT HAPPENS WHEN A MICROCONTROLLER IS TURNED ON?

here I will illustrate the flow of events that happen during the execution. 
I want to answer to questions such as:
  whats the first thing that happens? what's next?
  who is in charge of selecting the first instruction? is that address a default value?
  
I still have to figure that out myself.


* what is the most basic program one can write?


* how is the program loaded into program memory (flash memory)? from address 0?
-> yes, unless otherwisely specified 

* what's the first thing that happens when the microcontroller powers up?
-> program counter goet to address 0 of program memory (flash ROM)     -------------------> correct?

* who takes the first instruction? whence? 
-> program counter, default from first address on program memory (flash)


* what are .nolist and .list directives??
  -> they tell the assemblet not to list or list the result of the directives in the intermediate hex file!

. what does .cseg do? instructs the assembler to produce code??


