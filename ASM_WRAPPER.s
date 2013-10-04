	;Main assembly program
	
	AREA ASM_WRAPPER, CODE, READONLY

				EXPORT ASM_MAIN
				
				IMPORT teaData
				IMPORT teaKey
				IMPORT ASM_TEA_ENCRYPT
				IMPORT ASM_TEA_DECRYPT
				IMPORT ASM_TEA_ENCRYPT_STRING
				IMPORT ASM_TEA_DECRYPT_STRING
				
				;
				;	MAIN ASSEMBLY ENTRY POINT
				;
				;	REGISTER MAP
				;	R0		
				;	R1		
				;	R2		SCRATCH
				;	R3		SCRATCH
				;	R4		
				;	R5		
				;	R6		
				;	R7		
				;	R8		&DATA
				;	R9		&teaString
				;	R10		LENGTH
				;	R11		
				;	R12		
				
teaString DCB "Space: the final frontier. These are the voyages of the starship Enterprise. Its continuing mission to explore strange new worlds, to seek out new life and new civilizations, to boldly go where no one has gone before.", 0
				
ASM_MAIN		PUSH {R4-R12, LR}				;Store previous register states
				
				LDR R0, =teaKey					;Load &KEY into parameter register

				LDR R4, =0x2				;Generate KEY
				LDR R5, =0x0
				LDR R6, =0x1
				LDR R7, =0x3
				
				STM R0, {R4-R7}					;Store KEY into memory (teaKey)
				
				LDR R8, =teaData				;Initialize string destination location
				LDR R9, =teaString				;Initialize string source location
				MOV R2, #0						;Initialize string-copy counter
				MOV R10, #8
				
stringCopyLoop	LDRSB R3, [R9], #1				;Copy teaString to teaKey
				STR R3, [R8], #1
				ADD R2, R2, #1
				CMP R2, #8
				MOVEQ R2, #0
				ADDEQ R10, #8					;Store LENGTH (rounded up to nearest 8 bytes)
				CMP R3, #0
				BNE stringCopyLoop
				
donePadding		LDR R0, =teaKey					;Set Encrypt parameter registers
				LDR R1, =teaData
				MOV R2, R10
				
				BL ASM_TEA_ENCRYPT_STRING		;Encrypt string
				
				MOV R1, R0						;Set Decrypt parameter registers
				LDR R0, =teaKey
				MOV R2, R10
				
				BL ASM_TEA_DECRYPT_STRING		;Decrypt string
				
				POP {R4-R12, LR}				;Restore previous register states
				BX LR							;Return
				ALIGN
				
	END
