.global start
.set number1, 0x01AA02FE
.text
start:
	ldi r20, 0
	ldi r16, lo8(number1)
	ldi r17, hi8(number1)
	ldi r18, hh8(number1)
	ldi r19, hhi8(number1)
	add r16, r17
	brcc j01
	breq j02
	brpl j03
	brge j04
j01:
	ldi r20, 1
	rjmp infiniteloop
j02:
	ori r20, 2
	rjmp infiniteloop
j03:
	ori r20, 4
	rjmp infiniteloop
j04:
	ori r20, 8
infiniteloop:
	sts result1, r20
	rjmp infiniteloop
.data
.org 0x00A0
result1:
	.skip 4, 0xaa
result2:
	.skip 4, 0x55
