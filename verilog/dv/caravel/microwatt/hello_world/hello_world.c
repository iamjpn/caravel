#include <stdint.h>
#include <stdbool.h>

#include "console.h"

int main(void)
{
	console_init();

	puts("Microwatt lives\n");

	while (1) {
		unsigned char c = getchar();
		putchar(c);
		if (c == 13) // if CR send LF
			putchar(10);
	}
}
