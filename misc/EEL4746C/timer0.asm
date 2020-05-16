          .include "eel4746Cv3.inc"
          .global start
start:
init:
          initstack
        	sbi DDRB,0            ; Set pin 0 of Port B to output
        	ldi r16,0x42          ; Select Compare and Match mode
        	out TCCR0A,r16        ; Set Clear on Compare and Match mode
        	ldi r16,0x03          ; Select Clock Prescale 1/64
        	OUT TCCR0B,r16        ; Set Clock Prescale
        	ldi r16,125           ; Select Compare Value
        	OUT OCR0A,r16         ; Set Output Compare Register A
loop:
        	sbi PINB,0             ; Toggle the value of bit 0
        	rcall delay
        	rjmp loop
delay:
poll:
          in   r18, TIFR0
        	andi r18, 0x02         ; Mask for Output Compare A flag
        	breq poll              ; Check if Output Compare A flag is set
        	ldi  r18,0x02
        	out  TIFR0,r18         ; Clear Output Compare A flag
        	ret
