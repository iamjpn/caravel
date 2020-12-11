#include <stdint.h>
#include <stdbool.h>

#include "console.h"

int main(void)
{
	console_init();

	/* Echo everything we receive back */
	while (1) {
		unsigned char c = getchar();
		putchar(c);
		if (c == 13) // if CR send LF
			putchar(10);
	}
}
