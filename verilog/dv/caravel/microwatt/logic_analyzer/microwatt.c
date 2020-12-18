#include <stdint.h>
#include "microwatt_soc.h"
#include "io.h"
#include "console.h"

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

int main(void)
{
	unsigned int val = 0;
	console_init();

	val = readl(0xc8020000);
	print_hex_byte(val & 0xff);

	writel(val, 0xc8020000);
		
	for(;;);
}
