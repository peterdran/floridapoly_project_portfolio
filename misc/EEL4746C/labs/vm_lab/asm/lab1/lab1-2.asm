.global start
.text
start:
	ldi r31, hi8(a)
	ldi r30, lo8(a)
	ldi r16, 143
	st Z, r16
loop:
	rjmp loop
	.byte 30
	.hword 101
	.byte 20, 55

.data
.org 0x00A0
a:
	.byte 100,0
	.hword 40
