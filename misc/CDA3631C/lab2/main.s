	AREA MyCode, CODE, READONLY
	EXPORT main


;R1, R2: Inputs, addresses to beginning of array in memory with 32-bit values
;R3: Input, length of arrays
;NOTE: an assumption is made that the arrays are the same length
;R4: Output, address to beginning of array in memory with 32-bit values on output
main
	ENTRY
	CBZ R3, exit
	LDR R5, [R1]
	LDR R6, [R2]
	ADD R7, R6, R5
	STR R7, [R4]
	ADD R1, R1, #0x0004
	ADD R2, R2, #0x0004
	ADD R4, R4, #0x0004
	SUB R3, R3, #0x0001
	B main

exit	
	BX LR
	END
