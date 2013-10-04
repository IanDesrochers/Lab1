	;Data segment for ASM_TEA data
	
	AREA ASM_TEA_DATA, DATA, READWRITE
	
				EXPORT teaData
				EXPORT teaKey
	
teaData SPACE 1024
teaKey SPACE 16
	
	END