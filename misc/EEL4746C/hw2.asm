#"Probelm 1"
.global start
.text
#.set a0, 2
#.set a1, 35
#.set a2, 43
#.set a3, 37
#.set a4, 2
#.set a5, 13
#.set a6, 39
#.set a7, 4
#.set a8, 100
#.set a9, 200
#.set a10, 

inarr: .byte 2, 35, 43

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16 lo8(a0)
	

.data
.org 0x00A0
origarray:
	.skip 20*1
.end
################################################################################
#"Probelm 2"
#Square algo
.global start
.text
.set RAMEND, 0x08ff
.set SPL, 0x3d
.set SPH, 0x3e

.set n, 25525

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
	;since multiplying by same number, can shift the weights accordingly in a loop
	ldi r16, lo8(n)
	ldi r17, hi8(n)
	;extend as needed
	push r16
	push r17
	
	ldi r20, 1 ;LSB base 2 power position
	ldi r21, 0 ;MSB base 2 power position
	ldi r22, 0 ;counter
isshift:
	mov r23, r16
	mov r24, r17
	and r23, r20
	breq incr
	
	
incr:
	inc r22
	rjmp isshift

infloop:
	rjmp infloop
.end
################################################################################
#"Probelm 3"
#Sqrt algo
.global start
.text
.set RAMEND, 0x08ff
.set SPL, 0x3d
.set SPH, 0x3e

.set n, 25525

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
infloop:
	rjmp infloop
.end
################################################################################
#"Probelm 4"
#1 byte factorial (to 4 bytes out)
.global start
.text
.set RAMEND, 0x08ff
.set SPL, 0x3d
.set SPH, 0x3e

.set n, 25525

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
infloop:
	rjmp infloop
.end
################################################################################
#"Probelm 5"
#LS7400 tester
.global start
.text



.org 0x0000
	jmp start
.org 0x0100
start:
	
