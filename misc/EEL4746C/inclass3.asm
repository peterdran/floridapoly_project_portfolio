#hlc
#x=25, y=15
#t=max(x,y)
#t=t/2
#while(x%t != 0 || y%t != 0)
#	t--
#	if (t == 1) break
.global start
.text
.set a, 25
.set b, 15

.org 0x0000
	jmp start
.org 0x0100
start:
	ldi r16, lo8(a)
	ldi r17, lo8(b)
	cp r16, r17 ;max
	brsh 
	mov r18, r17
	rjmp gcdsub
skip:
	mov r18, r16
gcdsub:
	
	cp r16, r17
	breq infloop
	
	cp r16, r17
	breq infloop
	rjmp gcdsub 
infloop:
	rjmp infloop
.end