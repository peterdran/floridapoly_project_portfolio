.include "eel4746Cv3.inc"
initstack

init:
	sbi DDRD, 6
	sbi DDRB, 0
	ldi r16, 127
	out OCR0A, r16
	ldi r16, 0x81
	out TCCR0A, r16
	ldi r16, 0x03
	out TCCR0B, r16
	ldi r17, 0

loop:
	cpi r17, 2
	brsh skip
	sbi PINB,0

skip:
	call poll
	inc r17
	cpi r17, 20
	brne loop
	ldi r17, 0
	rjmp loop

poll:
	in r18, TIFR0
	andi r18, 0x02
	breq poll
	ldi r18, 0x02
	out TIFR0, r18
	ret


