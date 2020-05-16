#########################################################
# Filename: lab5.asm
# Version 1.1
# Description: Wig-wags the LED lights based on two input switches
# Author: Peter Dranishnikov
# Target: Atmel AtMega328p
# Assembler: avr-as (GNU)
# Last modified: Wednesday, Novermber 28th, 2018
#########################################################
.global start
.org 0x0000
.set PIND, 0x09
.set DDRD, 0x0A
.set PORTD, 0x0B

.set SPL, 0x3D
.set SPH, 0x3E
.set RAMEND, 0x08FF

reset_vector:
	rjmp start

.org 0x0068
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
	ldi r16, 0x0C
	out DDRD, r16
	
caseloop:
	;get input
	in r16, PIND
	andi r16, 0x03
	mov r17, r16
	mov r18, r16
	ldi r19, 0x04
	ldi r20, 0x08
	
	;case 00
	brne one
	clr r16
	
	out PORTD, r19 ;led 1 on
	rcall sixteenmillisecond
	andi r19, 0x00 ;led 1 off
	out PORTD, r19
	rcall sixteenmillisecond
	out PORTD, r20 ;led 2 on
	rcall sixteenmillisecond
	andi r20, 0x00 ;led 2 off
	out PORTD, r20
	rcall sixteenmillisecond
	rjmp caseloop
	
one:
	;case 01
	andi r17, 0x02
	brne two
	
	out PORTD, r19 ;led 1 on
	rcall thirtytwomillisecond
	andi r19, 0x00 ;led 1 off
	out PORTD, r19
	rcall thirtytwomillisecond
	out PORTD, r20 ;led 2 on
	rcall thirtytwomillisecond
	andi r20, 0x00 ;led 2 off
	out PORTD, r20
	rcall thirtytwomillisecond
	rjmp caseloop
	
two:
	;case 10
	andi r18, 0x01
	brne three
	
	out PORTD, r19 ;led 1 on
	rcall sixtyfourmillisecond
	andi r19, 0x00 ;led 1 off
	out PORTD, r19
	rcall sixtyfourmillisecond
	out PORTD, r20 ;led 2 on
	rcall sixtyfourmillisecond
	andi r20, 0x00 ;led 2 off
	out PORTD, r20
	rcall sixtyfourmillisecond
	rjmp caseloop
	
three:
	;case 11
	
	out PORTD, r19 ;led 1 on
	rcall onesixtymillisecond
	andi r19, 0x00 ;led 1 off
	out PORTD, r19
	rcall onesixtymillisecond
	out PORTD, r20 ;led 2 on
	rcall onesixtymillisecond
	andi r20, 0x00 ;led 2 off
	out PORTD, r20
	rcall onesixtymillisecond
	rjmp caseloop


sixteenmillisecond:
	nop
	dec r16
	brne sixteenmillisecond
	dec r21
	brne sixteenmillisecond
	ret

thirtytwomillisecond:
	rcall sixteenmillisecond
	rcall sixteenmillisecond
	ret

sixtyfourmillisecond:
	rcall thirtytwomillisecond
	rcall thirtytwomillisecond
	ret

onesixtymillisecond:
	rcall sixtyfourmillisecond
	rcall sixtyfourmillisecond
	rcall thirtytwomillisecond
	ret

.end
