#include <stdint.h>
#include "console.h"

#define FLASH_BASE 0xf0000000

void print_hex(unsigned long val)
{
	int i, x;

	for (i = 60; i >= 0; i -= 4) {
		x = (val >> i) & 0xf;
		if (x >= 10)
			putchar(x + 'a' - 10);
		else
			putchar(x + '0');
	}
}

int main(void)
{
	uint8_t *flash = (uint8_t *)FLASH_BASE;
	uint8_t val;

	console_init();
	putchar('S');
	__asm__ __volatile__("":::"memory");
	for (unsigned long i = 0; i < 10000; i++) ;
	val = *flash;
	__asm__ __volatile__("":::"memory");
	print_hex(val); // fixme
	putchar('F');

	while (1)
		;
}
