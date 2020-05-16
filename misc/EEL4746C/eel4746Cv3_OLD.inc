
.ifndef _EEL4746CV3_INC_
#define _EEL4746CV3_INC_

; Address Pointers
#define XH r27
#define XL r26
#define YH r29
#define YL r28
#define ZH r31
#define ZL r30

; Stack Pointer (I/O Internal Registers)
.set SPL, 0x3d
.set SPH, 0x3e

; Memory
.set RAMEND, 0x08ff

; I/O Ports
    ; Portt B
    .set PINB, 0x03
    .set DDRB, 0x04
    .set PORTB, 0x05

    ; Portt C
    .set PINC, 0x06
    .set DDRC, 0x07
    .set PORTC, 0x08

    ; Portt D
    .set PIND, 0x09
    .set DDRD, 0x0a
    .set PORTD, 0x0b

    ; initializing the Stack

.macro initstack
      jmp 0x0068
.org  0x0006
      jmp TCCIR0A
.org 0x0068
      ldi r16, hi8(RAMEND)
      out SPH, r16
      ldi r16, lo8(RAMEND)
      out SPL, r16
.endm

    ; Timers/Counters
    .set GTCCR, 0x23

    ; Timer/Counter 0
    .set TIFR0,  0x15
    .set TCCR0A, 0x24
    .set TCCR0B, 0x25
    .set TCNT0,  0x26
    .set OCR0A,  0x27
    .set OCR0B,  0x28
    .set TIMSK0, 0x6E


.endif
