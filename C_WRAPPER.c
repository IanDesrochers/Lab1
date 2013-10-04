//Main c program

//#include <stdio.h>
#include <string.h>

typedef unsigned long uint32_t;
typedef unsigned long long uint64_t;

extern void c_tea_encrypt(uint32_t *key, uint32_t *data);
extern void c_tea_decrypt(uint32_t *key, uint32_t *data);
extern char *c_tea_encrypt_string(uint32_t *, char *, uint32_t);
extern char *c_tea_decrypt_string(uint32_t *, char *, uint32_t);

extern uint64_t ASM_TEA_ENCRYPT(uint32_t *, uint32_t *);
extern uint64_t ASM_TEA_DECRYPT(uint32_t *, uint32_t *);
extern char *ASM_TEA_ENCRYPT_STRING(uint32_t *, char *, uint32_t);
extern char *ASM_TEA_DECRYPT_STRING(uint32_t *, char *, uint32_t);

int main() {
	
	uint32_t key[] = {0x45C5C07A, 0x40097CCE, 0x66, 0x68};
	uint32_t testData[] = {0x1234567, 0x89ABCDEF};
	//uint32_t Secret_Quote_Group_6[] = {0x7b6b37f9, 0xd10dc726, 0x40b55bb, 0x3a310b8e, 0x342c7c41, 0xf62fb160, 0xe3e55443, 0x656ce142, 0xba6bd276, 0xaaf3c532, 0x62f0ece4, 0x71c7d3eb, 0x3ed16f88, 0x9f4b9c9d, 0xb4dbb0fd, 0x285eedfc, 0x5f961f5b, 0x4e26ad65, 0xfdcfa429, 0x765cd73f, 0x502993b, 0xc080025f, 0x1b1a05c4, 0x3224c163, 0x32325d1b, 0x51f354ce};
	char value[] = "Space: the final frontier. These are the voyages of the starship Enterprise. Its continuing mission to explore strange new worlds, to seek out new life and new civilizations, to boldly go where no one has gone before.";
	
	//Add necessary whitespace to end of string to be 64b-aligned
	char paddedValue[(((sizeof(value)-1)/sizeof(char))/8)*8+8];
	strncpy(paddedValue, value, sizeof(value));
	
	//Test execution time on a single 64b segment (assembly)
	//ASM_TEA_ENCRYPT(key, testData);
	//ASM_TEA_DECRYPT(key, testData);
	
	//Test execution time on a single 64b segment (c)
	//c_tea_encrypt(key, testData);
	//c_tea_decrypt(key, testData);
	
	//Test string encryption (assembly)
	ASM_TEA_ENCRYPT_STRING(key, paddedValue, sizeof(paddedValue)/sizeof(char));
	ASM_TEA_DECRYPT_STRING(key, paddedValue, sizeof(paddedValue)/sizeof(char));
	
	//Test string encryption (c)
	//c_tea_encrypt_string(key, paddedValue, sizeof(paddedValue)/sizeof(char));
	//c_tea_decrypt_string(key, paddedValue, sizeof(paddedValue)/sizeof(char));

	return 0;
}
