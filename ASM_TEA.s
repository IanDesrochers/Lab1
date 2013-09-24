;	TEA encryption and decryption implemented in assembly
;
;	PARAMETERS
;	R0		&KEY	(128-bit)
;	R1		&VALUE	(64-bit)
;
;	RETURN
;	R0-R1	VALUE	(64-bit)
;
;	REGISTER MAP
;	R0		D0
;	R1		D1
;	R2		
;	R3		
;	R4		COUNTER
;	R5		T1
;	R6		T2
;	R7		T3
;	R8		T4
;	R9		&KEY
;	R10		SUM
;	R11		DELTA

	AREA ASM_TEA, CODE, READONLY
			
			EXPORT ASM_TEA_ENCRYPT
			EXPORT ASM_TEA_DECRYPT
			
ASM_TEA_ENCRYPT	PUSH {R4-R12}				;Save previous register states
				
				LDR R11, =0x9E3779B9		;Load DELTA
				MOV R9, R0					;Load KEY parameter
				LDM R1, {R0-R1}				;Load DATA parameter
				MOV R4, #32					;Initialize COUNTER
				LDR R10, =0					;Initialize SUM
				
ENCRYPTLOOP		ADD R10, R10, R11			;Increment SUM by DELTA
				
				LSL R5, R1, #4				;Calculate T1
				LDR R2, [R9]
				ADD R5, R5, R2
				
				LSR R6, R1, #5				;Calculate T2
				LDR R2, [R9, #4]
				ADD R6, R6, R2
				
				ADD R7, R1, R10				;Calculate T3
				
				EOR	R8, R5, R6				;Calculate T4
				EOR	R8, R8, R7
				
				ADD R0, R0, R8				;Calculate D0			
				
				LSL R5, R0, #4				;Calculate T1	
				LDR R2, [R9, #8]			
				ADD R5, R5, R2
				
				LSR R6, R0, #5				;Calculate T2
				LDR R2, [R9, #12]
				ADD R6, R6, R2
				
				ADD R7, R0, R10				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				ADD R1, R1, R8				;Calculate D1
				
				SUB R4, R4, #1				;Check if we're done all iterations
				CMP R4, #0
				BNE ENCRYPTLOOP
				
				POP {R4-R12}				;Restore previous register values
				BX LR
				
				
ASM_TEA_DECRYPT	PUSH {R4-R12}				;Save previous register states
				
				LDR R11, =0x9E3779B9		;Load DELTA
				MOV R9, R0					;Load KEY parameter
				LDM R1, {R0-R1}				;Load DATA parameter
				MOV R4, #32					;Initialize COUNTER
				LDR R10, =0xC6EF3720		;Initialize SUM
				
DECRYPTLOOP		
				LSL R5, R0, #4				;Calculate T1
				LDR R2, [R9, #8]
				ADD R5, R5, R2
				
				LSR R6, R0, #5				;Calculate T2
				LDR R2, [R9, #12]
				ADD R6, R6, R2
				
				ADD R7, R0, R10				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				SUB R1, R1, R8				;Calculate D0			
				
				LSL R5, R1, #4				;Calculate T1	
				LDR R2, [R9]			
				ADD R5, R5, R2
				
				LSR R6, R1, #5				;Calculate T2
				LDR R2, [R9, #4]
				ADD R6, R6, R2
				
				ADD R7, R1, R10				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				SUB R0, R0, R8				;Calculate D1
				
				SUB R10, R10, R11			;Decrement SUM by DELTA
				
				SUB R4, R4, #1				;Check if we're done all iterations
				CMP R4, #0
				BNE DECRYPTLOOP
				
				POP {R4-R12}				;Restore previous register values
				BX LR
				ALIGN
				
	END