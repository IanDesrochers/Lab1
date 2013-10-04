//#include <string.h>
//#include <stdlib.h>

typedef unsigned long uint32_t;

//TEA Encryption Algorithm (64b segment)
void c_tea_encrypt(uint32_t *key, uint32_t *data) {
  uint32_t sum=0, delta=0x9e3779b9, i;
  for (i=0; i < 32; i++) {
    sum += delta;
    data[0] += ((data[1]<<4) + key[0]) ^ (data[1] + sum) ^ ((data[1]>>5) + key[1]);
    data[1] += ((data[0]<<4) + key[2]) ^ (data[0] + sum) ^ ((data[0]>>5) + key[3]);  
  }
}

//TEA Decryption Algorithm (64b segment)
void c_tea_decrypt(uint32_t *key, uint32_t *data) {
	uint32_t sum=0xC6EF3720, delta=0x9e3779b9, i;
  for (i=0; i<32; i++) {
    data[1] -= ((data[0]<<4) + key[2]) ^ (data[0] + sum) ^ ((data[0]>>5) + key[3]);
    data[0] -= ((data[1]<<4) + key[0]) ^ (data[1] + sum) ^ ((data[1]>>5) + key[1]);
    sum -= delta;
	}
}

//Handles data of arbitrary length, encrypts 64b at a time and stores the result
char *c_tea_encrypt_string(uint32_t *key, char *data, uint32_t length) {
	uint32_t i;
	for (i=1; i<=length; i++) {																		//Loop through all 64b segments
		if (i % 8 == 0) {
			c_tea_encrypt(key, (uint32_t *)(data+i-8));								//Encrypt 64b segment in place
		}
	}
	return data;
}

//Handles data of arbitrary length, decrypts 64b at a time and stores the result
char *c_tea_decrypt_string(uint32_t *key, char *data, uint32_t length) {
	uint32_t i;
	for (i=1; i<=length; i++) {
		if (i % 8 == 0) {
			c_tea_decrypt(key, (uint32_t *)(data+i-8));
		}
	}
	return data;
}
