.global start
.text
.org 0x0000

.set op1, 15
.set op2, 16

reset_vector:
	jmp start

.org 0x0100
start:
	ldi r16, lo8(op1)
	ldi r17, lo8(op2)
	ldi r18, 0
	ldi r19, 1
do: ;do-while loop
	add r18, r16
	sub r17, r19
while:
	brne do


infiniteloop:
	rjmp infiniteloop
.end
