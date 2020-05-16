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
.org 0x0100 ;0x00A0 is wrong due to being in ext I/O instead of internal SRAM (based on memory map)
a:
	.byte 100,0
	.hword 40