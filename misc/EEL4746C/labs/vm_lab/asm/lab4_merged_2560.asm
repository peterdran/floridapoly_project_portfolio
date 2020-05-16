##############################################################################
# Filename: lab4_merged.asm
# Version 3.0.0
# Description: Merged version of parallel communications program
# Authors: Peter A. Dranishnikov and Dominic Lentini
# Target: Atmel AtMega2560
# Assembler: avr-as (GNU)
# Last modified: Monday, November 26th, 2018
##############################################################################
.global start
.text
# Port B comms (akshually portsee)
.set PINB, 0x06
.set DDRB, 0x07
.set PORTB, 0x08

# Port D switch input (actually port A but whatever)
.set PIND, 0x00
.set DDRD, 0x01
.set PORTD, 0x02

.set RAMEND, 0x08FF
.set SPL, 0x3D
.set SPH, 0x3E

.org 0x0000
reset_vector:
	rjmp start

.org 0x0100
start:
	ldi r16, hi8(RAMEND)
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16
	
	ldi r16, 0x07 ;parallel port initial mask
	out DDRB, r16
	
	ldi r16, 0x50 ;Port D output mask
	out DDRD, r16
	
	clr r1
	clr r2
	clr r3
	clr r4
	clr r5
	
#NOTICE: it is impossible to perform some commands directly to registers less than
# 16. perform a move if needed
	
mainloop:
	clr r16
	clr r17
	rcall pulseconfirm ;pulse logic check results must be handled
	rcall collectinput
	rcall postoutput
	rcall listen
	
	mov r16, r2 ;logic check
	andi r16, 0x02
	cpi r16, 0x02 ;check both bits
	breq spulse
	
	rjmp mainloop
spulse: 
	rcall handshake ;skip if check failed
	clr r2
	rjmp mainloop


pulseconfirm:
	nop
	dec r16
	brne pulseconfirm
	nop
	dec r17
	brne pulseconfirm
	
	in r16, PIND ;take input from pin d bit 3, store to r2
	andi r16, 0x08
	mov r18, r16
	mov r17, r2
	andi r17, 0x03
	or r18, r17
	andi r18, 0x09
	breq zeroexit
	
	ldi r19, 0x09
	cp r19, r18
	breq zeroexit
	
plus:
	inc r17
	
zeroexit:
	mov r2, r17
	ret


collectinput:
	in r16, PIND
	andi r16, 0x07 ;take input from pin d bits 0:2, store to r3
	mov r3, r16
	ret


postoutput:
	out PORTB, r4 ;post r4 to output port b bits 0:2
	ret


handshake:
	in r18, PIND
	andi r18, 0x80
	breq notTrue ;is port d bit 7 (foreign req to send) set?
	ret ;if true
	
notTrue:
	ldi r17, 0x10 ;else, set output port d bit 4 (req to send)
	out PORTD, r17
	
waitdel:
	nop
	in r17, PIND ;read input pin d bit 5 (foreign clr to send)
	andi r17, 0x20
	
	breq waitdel ;if not set, go back and check
	
	rcall send ;else continue to send
	clr r16
	clr r17
senddely:
	nop
	dec r16
	brne senddely
	nop
	dec r17
	brne senddely
	rcall unsend
	ret


send:
	ldi r16, 0x3F ;set output mask port b 0x3F
	out DDRB, r16
	mov r16, r3
	lsl r16 ;shifts for proper output
	lsl r16
	lsl r16
	out PORTB, r16 ;post r3 to output port b bits 3:5
	ret


unsend:
	ldi r16, 0x07 ;set output mask port b 0x07
	out DDRB, r16
	andi r16, 0x00 ;clear port d bit 4 (req to send)
	out PORTD, r16
	ret


listen:
	in r16, PIND
	andi r16, 0x80
	brne eListen;check if input pin d bit 7 is set
	ret ;if not
	
	ldi r16, 1
eListen: ;else set ouput port d bit 6
	ldi r17, 0x40
	out PORTD, r17
	in r18, PINB ;store input port b bits 3:5 to r4
	dec r16
	brne eListen
	andi r18, 0x38
	lsr r18
	lsr r18
	lsr r18 ;shift right to set as correct value
	mov r4, r18
	clr r17
	out PORTD, r17
	ret

.end
