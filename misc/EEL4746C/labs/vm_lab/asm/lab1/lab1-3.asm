####################################################################
# Filename: lab1-3.asm
# Version: 1.1 (lab manual version with documentation changes)
# Description: performs TODO
# Author: Original: Youssif Al-Nashif Derived: Peter A. Dranishnikov
# Target: Atmel AtMega328p AVR
# Assembler: avr-as
# Last modified: September 24th, 2018 (09/24/18)
####################################################################

.global start
.text
#alphabet soup is a bad idea
.set a, 10
.set b, 25
.set c, 15
.set d, -10
.set e, 246
start:
	ldi r16, a
	ldi r17, b
	ldi r18, 0
	cp r16, r17 ;compare content of r16 & r17
	breq if ;branch if equal
else:
	ldi r18, c
	rjmp endif
if:
	ldi r18, d
endif:
	mov r18, r18
loop:
	rjmp loop
.end
Anything can be written beyond this point
