#include <string.h>
#include <stdlib.h>

void c_tea_encrypt(unsigned int *key, unsigned int *data) {																		//TEA Encryption Algorithm (64-bit data)
  unsigned int sum=0, i;
  unsigned int delta=0x9e3779b9;
  for (i=0; i < 32; i++) {
    sum += delta;
    data[0] += ((data[1]<<4) + key[0]) ^ (data[1] + sum) ^ ((data[1]>>5) + key[1]);
    data[1] += ((data[0]<<4) + key[2]) ^ (data[0] + sum) ^ ((data[0]>>5) + key[3]);  
  }
}

void c_tea_decrypt(unsigned int *key, unsigned int *data) {																		//TEA Decryption Algorithm (64-bit data)
	unsigned int sum=0xC6EF3720, i;
  unsigned int delta=0x9e3779b9;
  for (i=0; i<32; i++) {
    data[1] -= ((data[0]<<4) + key[2]) ^ (data[0] + sum) ^ ((data[0]>>5) + key[3]);
    data[0] -= ((data[1]<<4) + key[0]) ^ (data[1] + sum) ^ ((data[1]>>5) + key[1]);
    sum -= delta;
	}
}

char *c_tea_encrypt_string(unsigned int *key, char *data, unsigned int length) {			//Manages what data is sent to be encrypted
	unsigned int i;																																							// and compiles encrypted output
	char *result_start = (char *)0x20001000;
	unsigned int rounded_length = 8 * (length / 8) + 8;
	for (i=1; i<=rounded_length; i++) {
		if (i<=length) {
			memcpy(result_start+i-1, &data[i-1], 1);
		} else {
			memset(result_start+i-1, 0, 1);
		}
		if (i % 8 == 0) {
			c_tea_encrypt(key, (unsigned int *)(result_start+i-8));
		}
	}
	return result_start;
}

char *c_tea_decrypt_string(unsigned int *key, char *data, unsigned int length) {			//Manages what data is send to be decrypted
	unsigned int i;																																							// and compiles the decrypted output
	char *result_start = data+0x1000;
	memcpy(result_start, data, length);
	for (i=1; i<=length; i++) {
		if (i % 8 == 0) {
			c_tea_decrypt(key, (unsigned int *)(result_start+i-8));
		}
	}
	return result_start;
}
