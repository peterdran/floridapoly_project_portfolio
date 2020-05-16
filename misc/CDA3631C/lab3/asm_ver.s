	AREA asm, CODE
	EXPORT findLowBitASM
	EXPORT mySystemInit
	
mySystemInit
	BX LR

findLowBitASM
	;Finds the lowest bit set in the contiguous values of the array
	;result is returned in R0 (apparently), C does some weird things with the stack values
	;do NOT touch R4, as that will mess with the C program's argument value, causing undefined behaviour
	MOV R5, #0x00 ;initialize position count at zero
	MOV R7, #0x00 ;removing will result in a HardFault, don't know why
	MOV R8, R0

postinit
	LDR R3, [R8]
	CBZ R3, none_found

shift_loop
	LSRS R3, R3, #0x01
	ADDCC R5, R5, #0x01
	BCC shift_loop
exit
	MOV R0, R5
	BX LR

none_found
	ADD R5, R5, #0x20 	;may be off by one
	SUB R7, R8, R0
	CMP R7, #0x1C 		;R0 >= 0x1C offset
	BEQ exit
	;else
	ADD R8, R8, #0x04
	B postinit
	
	END