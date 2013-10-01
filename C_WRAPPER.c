#include <stdio.h>
#include <string.h>
#include "EncrypteMessages.h"

extern char *c_tea_encrypt_string(unsigned int *, char *, unsigned int);
extern char *c_tea_decrypt_string(unsigned int *, char *, unsigned int);
extern char *ASM_TEA_ENCRYPT_STRING(unsigned int *, char *, unsigned int);
extern char *ASM_TEA_DECRYPT_STRING(unsigned int *, unsigned int *, unsigned int);

int main() {
	unsigned int key[] = {0x45C5C07A, 0x40097CCE, 0x64, 0x64};
unsigned int Secret_Quote_Group_6[] = {0x7b6b37f9, 0xd10dc726, 0x40b55bb, 0x3a310b8e, 0x342c7c41, 0xf62fb160, 0xe3e55443, 0x656ce142, 0xba6bd276, 0xaaf3c532, 0x62f0ece4, 0x71c7d3eb, 0x3ed16f88, 0x9f4b9c9d, 0xb4dbb0fd, 0x285eedfc, 0x5f961f5b, 0x4e26ad65, 0xfdcfa429, 0x765cd73f, 0x502993b, 0xc080025f, 0x1b1a05c4, 0x3224c163, 0x32325d1b, 0x51f354ce};


int i,j;
for (i=0x64; i<=0x68; i++) {
	key[2] = i;
	for (j=0x64; j<=0x68; j++) {
		key[3] = j;
		ASM_TEA_DECRYPT_STRING(key, Secret_Quote_Group_6, 104);
	}
}
	//char value[] = "012345670123456";

	//char *encrypted_result;
	
	//char paddedValue[(((sizeof(value)-1)/sizeof(char))/8)*8 +8];

	//strncpy(paddedValue, value, sizeof(value));

	//encrypted_result = c_tea_encrypt_string(key, value, sizeof(value)/sizeof(char));
	
	//c_tea_decrypt_string(key, encrypted_result, (sizeof(value)/sizeof(char));
	
	//encrypted_result = ASM_TEA_ENCRYPT_STRING(key, paddedValue, sizeof(value)/sizeof(char));
	
	//ASM_TEA_DECRYPT_STRING(key, paddedValue, (((sizeof(value)-1)/sizeof(char)) / 8) * 8 + 8);

	return 0;
}
