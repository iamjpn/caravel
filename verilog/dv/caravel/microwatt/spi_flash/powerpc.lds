MEMORY {
	FLASH (rx)	: ORIGIN = 0xf0000000, LENGTH = 0x400000	/* 4MB */
	RAM(xrw)	: ORIGIN = 0x00000000, LENGTH = 0x0400		/* 1024 kB */
}

SECTIONS
{
	. = 0xf0000000;
	_start = .;
	.text : {
		KEEP(*(.head))
		*(.text)
		*(.text.*)
		*(.sfpr)
		*(.eh_frame)
		*(.rodata)
		*(.rodata.*)
 	} > FLASH

	.data : {
	. = ALIGN(0x80);
	__bss_start = .;
		*(.data)
		*(.dynsbss)
		*(.sbss)
		*(.scommon)
		*(.dynbss)
		*(.bss)
		*(.common)
		*(.bss.*)

		. = . + 0x300;
		__stack_top = .;

		. = ALIGN(0x80);
		__bss_end = .;
	} > RAM
}
