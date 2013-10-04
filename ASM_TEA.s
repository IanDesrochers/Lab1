;	TEA encryption and decryption implemented in assembly

	AREA ASM_TEA, CODE, READONLY
				
				EXPORT ASM_TEA_ENCRYPT
				EXPORT ASM_TEA_DECRYPT
				EXPORT ASM_TEA_ENCRYPT_STRING
				EXPORT ASM_TEA_DECRYPT_STRING
				
				;
				;	ENCRYPT/DECRYPT 64b LOOP
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
				;	R2		SUM
				;	R3		DELTA
				;	R4		COUNTER
				;	R5		T1
				;	R6		T2
				;	R7		T3
				;	R8		T4
				;	R9		KEY0
				;	R10		KEY1
				;	R11		KEY2
				;	R12		KEY3
			
ASM_TEA_ENCRYPT	PUSH {R4-R12}				;Save previous register states
				
				LDR R3, =0x9E3779B9		;Load DELTA
				LDM R0, {R9-R12}				;Load KEY parameter
				LDM R1, {R0-R1}				;Load DATA parameter
				MOV R4, #32					;Initialize COUNTER
				LDR R2, =0					;Initialize SUM
				
				
ENCRYPTLOOP		ADD R2, R2, R3			;Increment SUM by DELTA
				
				LSL R5, R1, #4				;Calculate T1
				ADD R5, R5, R9
				
				LSR R6, R1, #5				;Calculate T2
				ADD R6, R6, R10
				
				ADD R7, R1, R2				;Calculate T3
				
				EOR	R8, R5, R6				;Calculate T4
				EOR	R8, R8, R7
				
				ADD R0, R0, R8				;Calculate D0			
				
				LSL R5, R0, #4				;Calculate T1				
				ADD R5, R5, R11
				
				LSR R6, R0, #5				;Calculate T2
				ADD R6, R6, R12
				
				ADD R7, R0, R2				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				ADD R1, R1, R8				;Calculate D1
				
				SUB R4, R4, #1				;Check if we're done all iterations
				CMP R4, #0
				BNE ENCRYPTLOOP
				
				POP {R4-R12}				;Restore previous register states
				BX LR						;Return
				
				
ASM_TEA_DECRYPT	PUSH {R4-R12}				;Save previous register states
				
				LDR R3, =0x9E3779B9		;Load DELTA
				LDM R0, {R9-R12}				;Load KEY parameter
				LDM R1, {R0-R1}				;Load DATA parameter
				MOV R4, #32					;Initialize COUNTER
				LDR R2, =0xC6EF3720		;Initialize SUM
				
				
DECRYPTLOOP		LSL R5, R0, #4				;Calculate T1
				ADD R5, R5, R11
				
				LSR R6, R0, #5				;Calculate T2
				ADD R6, R6, R12
				
				ADD R7, R0, R2				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				SUB R1, R1, R8				;Calculate D0			
				
				LSL R5, R1, #4				;Calculate T1			
				ADD R5, R5, R9
				
				LSR R6, R1, #5				;Calculate T2
				ADD R6, R6, R10
				
				ADD R7, R1, R2				;Calculate T3
				
				EOR R8, R5, R6				;Calculate T4
				EOR R8, R8, R7
				
				SUB R0, R0, R8				;Calculate D1
				
				SUB R2, R2, R3			;Decrement SUM by DELTA
				
				SUB R4, R4, #1				;Check if we're done all iterations
				CMP R4, #0
				BNE DECRYPTLOOP
				
				POP {R4-R12}				;Restore previous register states
				BX LR						;Return
				
				
				;
				;	ENCRYPT/DECRYPT STRING OF ARBITRARY LENGTH
				;
				;	PARAMETERS
				;	R0		&KEY	(128-bit)
				;	R1		&VALUE	(64-bit)
				;	R2		LENGTH
				;
				;	RETURN
				;	R0		&RESULT	(64-bit)
				;
				;	REGISTER MAP
				;	R0		
				;	R1		
				;	R2		
				;	R3		&DATA piece being (en/de)crypted
				;	R4		COUNTER
				;	R5		&KEY
				;	R6		&DATA
				;	R7		LENGTH
				;	R8		&RESULT
				;	R9		
				;	R10		
				;	R11		
				
ASM_TEA_ENCRYPT_STRING	PUSH {R4-R12,R14}	;Save previous register states
				LDR R4, =0					;Initialize counter
				MOV R5, R0					;Store parameter &KEY in register
				MOV R6, R1					;Store parameter &DATA in register
				MOV R7, R2					;Store parameter LENGTH in register
				;LDR R8, =0x20001000			;Define memory location for encrypted string
				
ENCRYPT_ITERATE	MOV R0, R5					;Move &KEY into parameter register
				ADD R1, R6, R4				;Add offset to &DATA and move into parameter register
				
				BL ASM_TEA_ENCRYPT			;Encrypt 64b of DATA
				ADD R3, R4, R6				;Calculate location to store this piece of encrypted DATA in
				STM R3, {R0-R1}				;Store this 64b of enrypted DATA in result memory area
				
				ADD R4, R4, #0x8			;Incrememnt counter
				CMP R4, R7					;Compare counter to length of string
				BLT ENCRYPT_ITERATE			;Repeat encrypt loop if we haven't reached the end
				
				MOV R0, R6					;Move result pointer into return register
				POP {R4-R12,R14}			;Restore previous register states
				BX LR						;Return
				

ASM_TEA_DECRYPT_STRING PUSH {R4-R12,R14}	;Save previous register states
				LDR R4, =0					;Initialize counter
				MOV R5, R0					;Store parameter &KEY in register
				MOV R6, R1					;Store parameter &DATA in register
				MOV R7, R2					;Store parameter LENGTH in register
				;LDR R8, =0x20002000			;Define memory location for decrypted string
				
DECRYPT_ITERATE	MOV R0, R5					;Move &KEY into parameter register
				ADD R1, R6, R4				;Add offset to &DATA and move into parameter register
				
				BL ASM_TEA_DECRYPT			;Decrypt 64b of DATA
				ADD R3, R4, R6				;Calculate location to store this piece of decrypted DATA in
				STM R3, {R0-R1}				;Store this 64b of encrypted DATA in result memory area
				
				ADD R4, R4, #0x8			;Increment counter
				CMP R7, R4					;Compare counter to length of string
				BNE DECRYPT_ITERATE			;Repeate decrypt loop if we haven't reached the end
				
				MOV R0, R6					;Move result pointer into return register
				POP {R4-R12,R14}			;Restore previous register states
				BX LR						;Return
				ALIGN
	END
