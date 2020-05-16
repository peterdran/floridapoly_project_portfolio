##############################################################################
# Author: Peter A. Dranishnikov and 
# 
# 
# 
# 
# 
##############################################################################
.global start
.text
# Port B comms
.set PINB, 0x03
.set DDRB, 0x04
.set PORTB, 0x05

# Port D switch input
.set PIND, 0x09
.set DDRD, 0x0A
.set PORTD, 0x0B

.set RAMEND 0x08FF
.set SPL, 0x3d
.set SPH, 0x3e

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
	
	ldi r16, 0xA0 ;Port D output mask
	out DDRD, r16
	
	
	
	
mainloop:
	rcall pulseconfirm ;pulse logic check results must be handled
	rcall collectinput
	rcall postoutput
	mov r16, r2 ;logic check
	andi r16, 0x02 ;check bit 1
	breq failpulse
	andi r2, 0x00 ;clear all if pass
	rcall handshake ;skip if check failed
failpulse: rcall listen
	
	rjmp mainloop
	
pulseconfirm:
	in r2, PIND ;take input from port d bit 3, store to r2
	;logic to confirm a full pulse
	andi r2, 0x04 ;0 to 1
	breq nextflip
	ori r2, 0x01 ;set bit 0 flag on r2
nextflip:
	andi r2, 0
	brne noflip
	;1 to 0
	;set bit 1 flag on r2
noflip:
	ret
	
collectinput:
	;take input from port d bits 0:2, store to r3
	ret
	
postoutput:
	;post r4 to output port b bits 0:2
	ret

handshake:
	;is port d bit 7 (foreign req to send) set?
	ret ;if true, return
	;else, set output port d bit 4 (req to send)
	;sleep n seconds
	;read input port d bit 5 (foreign clr to send)
	;if not set, go back to sleep
	call send;else
	call unsend
	ret

send:
	ldi r16, 0x3F ;set output mask port b 0x3F
	out DDRB, r16
	lsl r3 ;shift for proper output
	lsl r3
	lsl r3
	out PORTB, r3;post r3 to output port b bits 3:5
	ret

unsend:
	ldi r16, 0x07 ;set output mask port b 0x07
	out DDRB, r16
	andi r16, 0x00 ;clear port d bit 4 (req to send)
	out PORTD, r16
	ret

listen:
	in r16 PIND
	andi r16, 0x80 
	brne eListen;check if input port d bit 7 is set
	ret ;if not
eListen: ;else set ouput port d bit 6
	andi r17, 0x40
	in r18 PINB ;store input port b bits 3:5 to r4
	andi r18, 0x38
	mov r4, r18
	lsr r4
	lsr r4
	lsr r4 ;shift right to set as correct value
	ret

.org 0x00A0
.data
	
