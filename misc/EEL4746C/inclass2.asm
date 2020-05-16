.global start ;if commented, then external programs cannot see start
.text
.set v1, 100
.set v2, 20
.set v3, 113
.set v4, 87

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16, 0
	ldi r18, 0
	ldi r19, 0
	ldi r17, lo8(v1)
	add r18, r17
	adc r19, r16
	ldi r17, lo8(v2)
	add r18, r17
	adc r19, r16
	ldi r17, lo8(v3)
	add r18, r17
	adc r19, r16
	ldi r17, lo8(v4)
	add r18, r17
	adc r19, r16
	
	inc r16
	
	rjmp start

.data
	