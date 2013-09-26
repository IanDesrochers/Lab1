#include <stdio.h>

extern char *c_tea_encrypt_string(unsigned int *, char *, unsigned int);
extern char *c_tea_decrypt_string(unsigned int *, char *, unsigned int);

int main() {
	unsigned int key[] = {0, 1, 2, 3};
	char value[] = "A quick brown fox jumped over the lazy dog!";
	char *encrypted_result;
	encrypted_result = c_tea_encrypt_string(key, value, sizeof(value)/sizeof(char));
	c_tea_decrypt_string(key, encrypted_result, ((sizeof(value)/sizeof(char)) / 8) * 8 + 8);
	return 0;
}
