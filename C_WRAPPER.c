#include <stdio.h>
#include <string.h>

extern char *c_tea_encrypt_string(unsigned int *, char *, unsigned int);
extern char *c_tea_decrypt_string(unsigned int *, char *, unsigned int);
extern char *ASM_TEA_ENCRYPT_STRING(unsigned int *, char *, unsigned int);
extern char *ASM_TEA_DECRYPT_STRING(unsigned int *, char *, unsigned int);

int main() {
	unsigned int key[] = {0, 1, 2, 3};

	char value[] = "0123456701234567";

	char *encrypted_result;
	
	char paddedValue[(((sizeof(value)-1)/sizeof(char))/8)*8];

	strncpy(paddedValue, value, sizeof(value));

	//encrypted_result = c_tea_encrypt_string(key, value, sizeof(value)/sizeof(char));
	
	//c_tea_decrypt_string(key, encrypted_result, (((sizeof(value)-1)/sizeof(char)) / 8) * 8 + 8);
	
	encrypted_result = ASM_TEA_ENCRYPT_STRING(key, value, sizeof(value)/sizeof(char));

	ASM_TEA_DECRYPT_STRING(key, encrypted_result, (((sizeof(value)-1)/sizeof(char)) / 8) * 8 + 8);

	return 0;
}
