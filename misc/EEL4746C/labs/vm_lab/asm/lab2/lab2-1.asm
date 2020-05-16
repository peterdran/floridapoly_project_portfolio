.text
.org 0x0000 ;default

.set op1, 100020
.set op2, 2052

reset_vector:
	jmp start

.org 0x0100 ;correct starting locations (Interrupt vector table)
start:
	ldi r16, lo8(op1)
	ldi r17, hi8(op1)
	ldi r18, hlo8(op1)
	ldi r19, hhi8(op1)

	sts m, r16
	sts m+1, r17
	sts m+2, r18
	sts m+3, r19

	ldi r16, lo8(op2)
	ldi r17, hi8(op2)
	ldi r18, hlo8(op2)
	ldi r19, hhi8(op2)

	sts n, r16
	sts n+1, r17
	sts n+2, r18
	sts n+3, r19

	lds r16, m
	lds r17, m+1
	lds r18, m+2
	lds r19, m+3

	lds r20, n
	lds r21, n+1
	lds r22, n+2
	lds r23, n+3

	add r16, r20
	adc r17, r21
	adc r18, r22
	adc r19, r23

	sts o, r16
	sts o+1, r17
	sts o+2, r18
	sts o+3, r19

infiniteloop:
	rjmp infiniteloop
.data
.org 0x00A0
m:
	.skip 4, 0
n:
	.skip 4, 20
o:
	.skip 4, 40
.end
