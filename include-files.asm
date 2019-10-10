.equ	OCR1B0	= 0	; Output Compare Register B Bit 0
.equ	OCR1B1	= 1	; Output Compare Register B Bit 1
.equ	OCR1B2	= 2	; Output Compare Register B Bit 2
.equ	OCR1B3	= 3	; Output Compare Register B Bit 3
.equ	OCR1B4	= 4	; Output Compare Register B Bit 4
.equ	OCR1B5	= 5	; Output Compare Register B Bit 5
.equ	OCR1B6	= 6	; Output Compare Register B Bit 6
.equ	OCR1B7	= 7	; Output Compare Register B Bit 7

; OCR1C - Output compare register
.equ	OCR1C0	= 0	; 
.equ	OCR1C1	= 1	; 
.equ	OCR1C2	= 2	; 
.equ	OCR1C3	= 3	; 
.equ	OCR1C4	= 4	; 
.equ	OCR1C5	= 5	; 
.equ	OCR1C6	= 6	; 
.equ	OCR1C7	= 7	; 

; TIMSK - Timer/Counter Interrupt Mask Register
.equ	TOIE1	= 2	; Timer/Counter1 Overflow Interrupt Enable
.equ	OCIE1B	= 5	; OCIE1A: Timer/Counter1 Output Compare B Interrupt Enable
.equ	OCIE1A	= 6	; OCIE1A: Timer/Counter1 Output Compare Interrupt Enable

; TIFR - Timer/Counter Interrupt Flag Register
.equ	TOV1	= 2	; Timer/Counter1 Overflow Flag
.equ	OCF1B	= 5	; Timer/Counter1 Output Compare Flag 1B
.equ	OCF1A	= 6	; Timer/Counter1 Output Compare Flag 1A

; GTCCR - Timer counter control register
.equ	PSR1	= 1	; Prescaler Reset Timer/Counter1
.equ	FOC1A	= 2	; Force Output Compare 1A
.equ	FOC1B	= 3	; Force Output Compare Match 1B
.equ	COM1B0	= 4	; Comparator B Output Mode
.equ	COM1B1	= 5	; Comparator B Output Mode
.equ	PWM1B	= 6	; Pulse Width Modulator B Enable

; DTPS - Dead time prescaler register
.equ	DTPS0	= 0	; 
.equ	DTPS1	= 1	; 

; DT1A - Dead time value register
.equ	DTVL0	= 0	; 
.equ	DTVL1	= 1	; 
.equ	DTVL2	= 2	; 
.equ	DTVL3	= 3	; 
.equ	DTVH0	= 4	; 
.equ	DTVH1	= 5	; 
.equ	DTVH2	= 6	; 
.equ	DTVH3	= 7	; 

; DT1B - Dead time value B
;.equ	DTVL0	= 0	; 
;.equ	DTVL1	= 1	; 
;.equ	DTVL2	= 2	; 
;.equ	DTVL3	= 3	; 
;.equ	DTVH0	= 4	; 
;.equ	DTVH1	= 5	; 
;.equ	DTVH2	= 6	; 
;.equ	DTVH3	= 7	; 


; ***** BOOT_LOAD ********************
; SPMCSR - Store Program Memory Control Register
.equ	SPMEN	= 0	; Store Program Memory Enable
.equ	PGERS	= 1	; Page Erase
.equ	PGWRT	= 2	; Page Write
.equ	RFLB	= 3	; Read fuse and lock bits
.equ	CTPB	= 4	; Clear temporary page buffer


; ***** CPU **************************
; SREG - Status Register
.equ	SREG_C	= 0	; Carry Flag
.equ	SREG_Z	= 1	; Zero Flag
.equ	SREG_N	= 2	; Negative Flag
.equ	SREG_V	= 3	; Two's Complement Overflow Flag
.equ	SREG_S	= 4	; Sign Bit
.equ	SREG_H	= 5	; Half Carry Flag
.equ	SREG_T	= 6	; Bit Copy Storage
.equ	SREG_I	= 7	; Global Interrupt Enable

; MCUCR - MCU Control Register
;.equ	ISC00	= 0	; Interrupt Sense Control 0 bit 0
;.equ	ISC01	= 1	; Interrupt Sense Control 0 bit 1
.equ	SM0	= 3	; Sleep Mode Select Bit 0
.equ	SM1	= 4	; Sleep Mode Select Bit 1
.equ	SE	= 5	; Sleep Enable
.equ	PUD	= 6	; Pull-up Disable

; MCUSR - MCU Status register
.equ	PORF	= 0	; Power-On Reset Flag
.equ	EXTRF	= 1	; External Reset Flag
.equ	BORF	= 2	; Brown-out Reset Flag
.equ	WDRF	= 3	; Watchdog Reset Flag

; PRR - Power Reduction Register
.equ	PRADC	= 0	; Power Reduction ADC
.equ	PRUSI	= 1	; Power Reduction USI
.equ	PRTIM0	= 2	; Power Reduction Timer/Counter0
.equ	PRTIM1	= 3	; Power Reduction Timer/Counter1

; OSCCAL - Oscillator Calibration Register
.equ	CAL0	= 0	; Oscillatro Calibration Value Bit 0
.equ	CAL1	= 1	; Oscillatro Calibration Value Bit 1
.equ	CAL2	= 2	; Oscillatro Calibration Value Bit 2
.equ	CAL3	= 3	; Oscillatro Calibration Value Bit 3
.equ	CAL4	= 4	; Oscillatro Calibration Value Bit 4
.equ	CAL5	= 5	; Oscillatro Calibration Value Bit 5
.equ	CAL6	= 6	; Oscillatro Calibration Value Bit 6
.equ	CAL7	= 7	; Oscillatro Calibration Value Bit 7

; PLLCSR - PLL Control and status register
.equ	PLOCK	= 0	; PLL Lock detector
.equ	PLLE	= 1	; PLL Enable
.equ	PCKE	= 2	; PCK Enable
.equ	LSM	= 7	; Low speed mode

; CLKPR - Clock Prescale Register
.equ	CLKPS0	= 0	; Clock Prescaler Select Bit 0
.equ	CLKPS1	= 1	; Clock Prescaler Select Bit 1
.equ	CLKPS2	= 2	; Clock Prescaler Select Bit 2
.equ	CLKPS3	= 3	; Clock Prescaler Select Bit 3
.equ	CLKPCE	= 7	; Clock Prescaler Change Enable

; DWDR - debugWire data register
.equ	DWDR0	= 0	; 
.equ	DWDR1	= 1	; 
.equ	DWDR2	= 2	; 
.equ	DWDR3	= 3	; 
.equ	DWDR4	= 4	; 
.equ	DWDR5	= 5	; 
.equ	DWDR6	= 6	; 
.equ	DWDR7	= 7	; 

; GPIOR2 - General Purpose IO register 2
.equ	GPIOR20	= 0	; 
.equ	GPIOR21	= 1	; 
.equ	GPIOR22	= 2	; 
.equ	GPIOR23	= 3	; 
.equ	GPIOR24	= 4	; 
.equ	GPIOR25	= 5	; 
.equ	GPIOR26	= 6	; 
.equ	GPIOR27	= 7	; 

; GPIOR1 - General Purpose register 1
.equ	GPIOR10	= 0	; 
.equ	GPIOR11	= 1	; 
.equ	GPIOR12	= 2	; 
.equ	GPIOR13	= 3	; 
.equ	GPIOR14	= 4	; 
.equ	GPIOR15	= 5	; 
.equ	GPIOR16	= 6	; 
.equ	GPIOR17	= 7	; 

; GPIOR0 - General purpose register 0
.equ	GPIOR00	= 0	; 
.equ	GPIOR01	= 1	; 
.equ	GPIOR02	= 2	; 
.equ	GPIOR03	= 3	; 
.equ	GPIOR04	= 4	; 
.equ	GPIOR05	= 5	; 
.equ	GPIOR06	= 6	; 
.equ	GPIOR07	= 7	; 



; ***** LOCKSBITS ********************************************************
.equ	LB1	= 0	; Lockbit
.equ	LB2	= 1	; Lockbit


; ***** FUSES ************************************************************
; LOW fuse bits
.equ	CKSEL0	= 0	; Select Clock source
.equ	CKSEL1	= 1	; Select Clock source
.equ	CKSEL2	= 2	; Select Clock source
.equ	CKSEL3	= 3	; Select Clock source
.equ	SUT0	= 4	; Select start-up time
.equ	SUT1	= 5	; Select start-up time
.equ	CKOUT	= 6	; Clock Output Enable
.equ	CKDIV8	= 7	; Divide clock by 8

; HIGH fuse bits
.equ	BODLEVEL0	= 0	; Brown-out Detector trigger level
.equ	BODLEVEL1	= 1	; Brown-out Detector trigger level
.equ	BODLEVEL2	= 2	; Brown-out Detector trigger level
.equ	EESAVE	= 3	; EEPROM memory is preserved through the Chip Erase
.equ	WDTON	= 4	; Watchdog Timer always on
.equ	SPIEN	= 5	; Enable Serial Program and Data Downloading
.equ	DWEN	= 6	; DebugWIRE Enable
.equ	RSTDISBL	= 7	; External Reset disable

; EXTENDED fuse bits
.equ	SELFPRGEN	= 0	; Self-Programming Enable



; ***** CPU REGISTER DEFINITIONS *****************************************
.def	XH	= r27
.def	XL	= r26
.def	YH	= r29
.def	YL	= r28
.def	ZH	= r31
.def	ZL	= r30



; ***** DATA MEMORY DECLARATIONS *****************************************
.equ	FLASHEND	= 0x0fff	; Note: Word address
.equ	IOEND	= 0x003f
.equ	SRAM_START	= 0x0060
.equ	SRAM_SIZE	= 512
.equ	RAMEND	= 0x025f
.equ	XRAMEND	= 0x0000
.equ	E2END	= 0x01ff
.equ	EEPROMEND	= 0x01ff
.equ	EEADRBITS	= 9
#pragma AVRPART MEMORY PROG_FLASH 8192
#pragma AVRPART MEMORY EEPROM 512
#pragma AVRPART MEMORY INT_SRAM SIZE 512
#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60



; ***** BOOTLOADER DECLARATIONS ******************************************
.equ	NRWW_START_ADDR	= 0x0
.equ	NRWW_STOP_ADDR	= 0xfff
.equ	RWW_START_ADDR	= 0x0
.equ	RWW_STOP_ADDR	= 0x0
.equ	PAGESIZE	= 32



; ***** INTERRUPT VECTORS ************************************************
.equ	INT0addr	= 0x0001	; External Interrupt 0
.equ	PCI0addr	= 0x0002	; Pin change Interrupt Request 0
.equ	OC1Aaddr	= 0x0003	; Timer/Counter1 Compare Match 1A
.equ	OVF1addr	= 0x0004	; Timer/Counter1 Overflow
.equ	OVF0addr	= 0x0005	; Timer/Counter0 Overflow
.equ	ERDYaddr	= 0x0006	; EEPROM Ready
.equ	ACIaddr	= 0x0007	; Analog comparator
.equ	ADCCaddr	= 0x0008	; ADC Conversion ready
.equ	OC1Baddr	= 0x0009	; Timer/Counter1 Compare Match B
.equ	OC0Aaddr	= 0x000a	; Timer/Counter0 Compare Match A
.equ	OC0Baddr	= 0x000b	; Timer/Counter0 Compare Match B
.equ	WDTaddr	= 0x000c	; Watchdog Time-out
.equ	USI_STARTaddr	= 0x000d	; USI START
.equ	USI_OVFaddr	= 0x000e	; USI Overflow

.equ	INT_VECTORS_SIZE	= 15	; size in words

#endif  /* _TN85DEF_INC_ */

; ***** END OF FILE ******************************************************
