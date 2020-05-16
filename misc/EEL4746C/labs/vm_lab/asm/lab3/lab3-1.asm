.global start
.text
# Port D in
.set PIND, 0x09
.set DDRD, 0x0A
.set PORTD, 0x0B

# Port B out
.set PINB, 0x03
.set DDRB, 0x04
.set PORTB, 0x05

.org 0x0000
reset_vector:
	jmp start
.org 0x0100
start:
	ldi r16, 0x0F
	out DDRB, r16
	
	ldi r17, 0x00
	out DDRD, r17

repeat:
	in r18, PIND
	
	and r18, r16
	
	out PORTB, r18
	
	rjmp repeat

.end
