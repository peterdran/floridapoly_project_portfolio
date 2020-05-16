#########################################################
# Filename: lab6.asm
# Version 1.0.1
# Description: Selectable pulse-width generator
# Author: Peter Dranishnikov
# Target: Atmel AtMega328p
# Assembler: avr-as (GNU)
# Last modified: Wednesday, November 28th, 2018
#########################################################
.global start
.org 0x0000

.set PIND, 0x09
.set DDRD, 0x0A
.set PORTD, 0x0B

.set SPL, 0x03D
.set SPH, 0x03E
.set RAMEND, 0x08FF

reset_vector:
	rjmp start

.org 0x0068
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
	ldi r16, 0x08
	out DDRD, r16
	
mainloop:
# definitions:
# 0 -> 500 usec
# 1 -> 1 ms (== 1000 usec)
# 2 -> 1.3 ms (== 1300 usec)
# 3 -> 1.7 ms (== 1700 usec)
# 4 -> 2 ms (== 2000 usec)
# 5 -> 4 ms (== 4000 usec)
# 6 -> 8 ms (== 8000 usec)
# 7 -> 12 ms (== 12000 usec)
#
# Wave properties:
# Period length: 0.02 sec (== 20 ms == 20000 usec)

#set number
	in r18, PIND
	ldi r16, 0x08
	out PORTD, r16
	
	;case 0
	mov r17, r18
	cpi r17, 0x00
	brne one
	ldi r19, 5
	mov r16, r19
	rcall delay
	rjmp breakout
one:;case 1
	mov r17, r18
	cpi r17, 0x01
	brne two
	ldi r19, 10
	mov r16, r19
	rcall delay
	rjmp breakout
two:;case 2
	mov r17, r18
	cpi r17, 0x02
	brne three
	ldi r19, 13
	mov r16, r19
	rcall delay
	rjmp breakout
three:;case 3
	mov r17, r18
	cpi r17, 0x03
	brne four
	ldi r19, 17
	mov r16, r19
	rcall delay
	rjmp breakout
four:;case 4
	mov r17, r18
	cpi r17, 0x04
	brne five
	ldi r19, 20
	mov r16, r19
	rcall delay
	rjmp breakout
five:;case 5
	mov r17, r18
	cpi r17, 0x05
	brne six
	ldi r19, 40
	mov r16, r19
	rcall delay
	rjmp breakout
six:;case 6
	mov r17, r18
	cpi r17, 0x06
	brne seven
	ldi r19, 80
	mov r16, r19
	rcall delay
	rjmp breakout
seven:;case 7
	ldi r19, 120
	mov r16, r19
	
	rcall delay
	
breakout:
	ldi r20, 0xFF ;255 - r19
	sub r20, r19
	ldi r16, 0x00
	out PORTD, r16
	mov r16, r20
	rcall delay
	ldi r16, 207
	rcall delay
	rjmp mainloop

delay:
	clr r21
	add r16, r16
	inc r16
loop:
	dec r21
	brne loop
	dec r16
	brne loop
	ret

.end
