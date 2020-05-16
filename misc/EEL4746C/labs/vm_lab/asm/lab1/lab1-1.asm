.global start
.text
start:
	ldi r31, hi8(a)
	ldi r30, lo8(a)
	ldi r16, 143
	st Z, r16

loop:
	rjmp loop


.data
.org 0x00A0 ;start of RAM for this assembler
a:
	.byte 100,0 ;not values
	.hword 40 ;but address space will be reserved
