.global start
.text
.org 0x0000

.set op1, 23
.set op2, 155
.set op3, 211

reset_vector:
	jmp start

.org 0x0100
start: ;3 operands in a range of a byte
	ldi r16, lo8(op1)
	ldi r17, lo8(op2)
	ldi r18, lo8(op3)
	
	mov r20, r16 ;min
	mov r21, r16 ;max
	mov r19, r16
	
	sub r19, r17 ;r16 >, <, = r17 ?
	breq skip1
	brlo less1
	mov r20, r17
	rjmp skip1
less1:
	mov r21, r17
skip1:
	mov r19, r18
	sub r19, r21 ;r18 >, <, = r21(max) ?
	brlo skip2
	mov r21, r18
skip2:
	mov r19, r18
	sub r19, r20
	brlo less2
	rjmp skip3
less2:
	mov r20, r18
skip3:
	rjmp skip3
.end