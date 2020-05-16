#########################################################
# Filename: lab3-3.asm
# Version: 1.0
# Description: Adds two 3-bit inputs in sequence (toggled by 1 separate bit)
# Author: Peter Dranishnikov
# Target: Atmel AtMega328p AVR
# Assembler: avr-as (GNU)
# Last modified: Sunday, October 14th, 2018, 13:04:11 EST
#########################################################
.global start
.text
# Port D in
.set PIND, 0x09 ;dat reg
.set DDRD, 0x0A ;dat dir reg
.set PORTD, 0x0B ;ir

# Port B out
.set PINB, 0x03 ;dat reg
.set DDRB, 0x04 ;dat dir reg
.set PORTB, 0x05 ;ir

.org 0x0000
reset_vector:
	jmp start
.org 0x0100

start:
	ldi r16, 0x0F
	out DDRB, r16
	
	ldi r17, 0x00
	out DDRD, r17

check:
#state flag check
	in r18, PIND
	mov r20, r18
	
	andi r20, 0x08 ;upper bit (state) mask
	breq instore ;branch to input if state flag 0
	
#sum
	andi r18, 0x07 ;lower 3 bits mask
	add r18, r21 ;the addition
	
	out PORTB, r18
	rjmp check

instore:
	andi r18, 0x07 ;lower 3 bits mask
	mov r21, r18
	
	out PORTB, r21 ;echo input
	
	rjmp check

.end
Introduction:
	The objective of this lab was to 

Discussion: see source code above .end

Procedure: 
Assembled code above using avr-as, linked using avr-ld, created hex file for flashing using avr-objcopy, and flashed to board EEPROM using avrdude
Constructed the four switches and the four output LED circuits, connected to the correct board pins, and applied power for testing. 

Results: Works as intended. See board for live demonstration
Results discussion: This program used I/O addressing and operations, but can be modified to use Memory-mapped I/O

Conclusion: It is possible to create an AVR assembly program to input from an external parallel port, process it, and output the result on a different parallel port

Answers to questions:
Part 1: What does this code (1) do?
This program simply echos the input port to the output port using I/O addressing & instructions
Part 2: What does this code (2) do?
This program inverts/complements the input to the output port using Memory-Mapped I/O and memory access instructions
