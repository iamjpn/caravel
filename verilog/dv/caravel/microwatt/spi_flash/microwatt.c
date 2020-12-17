#include <stdint.h>
#include "console.h"

#define FLASH_BASE 0xf0000000

void print_hex_byte(unsigned long val)
{
	int i, x;

	for (i = 4; i >= 0; i -= 4) {
		x = (val >> i) & 0xf;
		if (x >= 10)
			putchar(x + 'a' - 10);
		else
			putchar(x + '0');
	}
}

/*
 * Expecting to see:
    f0000000:   00 00 ff 63     ori     r31,r31,0
    f0000004:   00 00 21 60     ori     r1,r1,0
    f0000008:   00 00 10 62     ori     r16,r16,0
 */
int main(void)
{
	uint8_t *flash = (uint8_t *)FLASH_BASE;
	uint8_t val;

	console_init();
	putchar('S');

	for (unsigned long i = 0; i < 12; i++) {
		__asm__ __volatile__("":::"memory");
		val = *(flash + i);
		__asm__ __volatile__("":::"memory");
		print_hex_byte(val);
	}
		
	putchar('F');

	while (1)
		;
}
