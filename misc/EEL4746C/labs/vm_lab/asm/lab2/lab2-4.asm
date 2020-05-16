################################################################################
# Filename: lab2-4.asm
# Version: 1.0
# Description: Computes the (integer) average of 8, 8-bit numbers
# Author: Peter A. Dranishnikov
# Target: Atmel AtMega328p AVR
# Assembler: avr-as (GNU)
# Last modified: Thursday, October 4th 2018, 23:18:27 EST
################################################################################

.global start
.text
.org 0x0000

.set op1, 200
.set op2, 123
.set op3, 2
.set op4, 32
.set op5, 21
.set op6, 111
.set op7, 97
.set op8, 255

.set zero, 0
.set one, 1

reset_vector:
	jmp start

.org 0x0100
start:
	ldi r16, lo8(op1)
	ldi r17, lo8(op2)
	ldi r18, lo8(op3)
	ldi r19, lo8(op4)
	ldi r20, lo8(op5)
	ldi r21, lo8(op6)
	ldi r22, lo8(op7)
	ldi r23, lo8(op8)
	ldi r24, lo8(zero)
	ldi r25, lo8(one)
	sts ps1+1, r24
	sts ps2+1, r24
	sts ps3+1, r24
	sts ps4+1, r24
	
#since 8*255 < 2^16-1, there is no risk of overflow
	add r16, r17
	brcc sk1 ;skips if no carry
	sts ps1+1, r25 ;assigns carry bit to next byte
sk1:
	sts ps1, r16
	
	add r18, r19
	brcc sk2
	sts ps2+1, r25
sk2:
	sts ps2, r18
	
	add r20, r21
	brcc sk3
	sts ps3+1, r25
sk3:
	sts ps3, r20
	
	add r22, r23
	brcc sk4
	sts ps4+1, r25
sk4:
	sts ps4, r22
	
#partial addition
	lds r16, ps1
	lds r17, ps1+1
	lds r18, ps2
	lds r19, ps2+1
	lds r20, ps3
	lds r21, ps3+1
	lds r22, ps4
	lds r23, ps4+1
	
	add r16, r18
	adc r17, r19
	sts ps1, r16
	sts ps1+1, r17
	
	add r20, r22
	adc r21, r23
	sts ps2, r20
	sts ps2+1, r21
	
#final addition
	lds r16, ps1
	lds r17, ps1+1
	lds r18, ps2
	lds r19, ps2+1
	
	add r16, r18
	adc r17, r19
	sts sum, r16
	sts sum+1, r17
	
#division part
#IMHO, I would perform a LSR and an ASR here on all parts and handle carryover since
#denominator is 8, but since hint mentioned division by subtraction, here it is
	
	lds r16, sum
	lds r17, sum+1
	ldi r18, 0 ;counter
	ldi r19, 8 ;denominator
	
divloop:
	sub r16, r19
	brlo borrower
	inc r18
	rjmp divloop
borrower:
#see if upper byte has values, subtract as necessary
	sub r17, r25 ;cannot use dec due to flag behaviour
	brlo infloop
	inc r18
	rjmp divloop

infloop:
	rjmp infloop
.data
.org 0x00A0
#even if all values are full (255), then only 2 bytes are needed for each variable
ps1:
	.skip 2 ;1st partial sum in ISRAM
ps2:
	.skip 2 ;2nd partial sum in ISRAM
ps3:
	.skip 2 ;3rd partial sum in ISRAM
ps4:
	.skip 2 ;4th partial sum in ISRAM
sum:
	.skip 2 ;full sum
.end
