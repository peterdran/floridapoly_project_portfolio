;	AREA MyData, DATA
;	
;array1
;	DCD 0x87654321, 0x23456789, 0x3456789A
;array2
;	DCD 0xAABBCCDD, 0x7FCCDDEE, 0xCCDDEEFF
;	
;	AREA MyAnswers, DATA
;array3
;	SPACE 12

	AREA MyCode, CODE, READONLY
	EXPORT	__main
	EXPORT mySystemInit
	IMPORT main

mySystemInit
	BX LR

__main
	ENTRY
	MOVW.W R1, #0x0000
	MOVT.W R1, #0x2000 ;array1 base addr
	ADD R2, R1, #0x000C ;array2 base addr
	ADD R4, R2, #0x000C ;ansarray base addr
	
;array1 initial values
	MOVW.W R5, #0x4321
	MOVT.W R5, #0x8765
	STR R5, [R1]
	
	MOVW.W R5, #0x6789
	MOVT.W R5, #0x2345
	STR R5, [R1, #0x0004]
	
	MOVW.W R5, #0x789A
	MOVT.W R5, #0x3456
	STR R5, [R1, #0x0008]
	
;array2 initial values
	MOVW.W R5, #0xCCDD
	MOVT.W R5, #0xAABB
	STR R5, [R2]
	
	MOVW.W R5, #0xDDEE
	MOVT.W R5, #0x7FCC
	STR R5, [R2, #0x0004]
	
	MOVW.W R5, #0xEEFF
	MOVT.W R5, #0xCCDD
	STR R5, [R2, #0x0008]
	
;subroutine call to 'main' (see docstring for params)
	MOVW.W R3, #0x0003
	LDR R0, =main
	BLX R0
;__main
;	ENTRY
;	LDR R0, =array1
;	LDR R1, =array2
;	LDR R2, =array3
;	
;	LDR R3, [R0], #4
;	LDR R4, [R1], #4
;	ADDS R4, R3, R4
;	STR R4, [R2], #4
;	
;	LDR R3, [R0], #4
;	LDR R4, [R1], #4
;	ADDS R4, R3, R4
;	STR R4, [R2], #4	
;	
;	LDR R3, [R0]
;	LDR R4, [R1]
;	ADDS R4, R3, R4
;	STR R4, [R2]	
;;comment	
;	LDR R0, =0x22000000
;	LDR R1, =32
;loop
;;	LDR R2, [R0], #4
;;	SUBS R1, #1
;;	BNE loop
;;endcomment
;	
	B	.
	END
