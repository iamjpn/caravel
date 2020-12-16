MEMORY {
	FLASH (rx)	: ORIGIN = 0xf0000000, LENGTH = 0x400000	/* 4MB */
	RAM(xrw)	: ORIGIN = 0x00000000, LENGTH = 0x0400		/* 1024 kB */
}

SECTIONS
{
	.text : {
		KEEP(*(.head))
		*(.text)
		*(.text.*)
		*(.sfpr)
		*(.eh_frame)
 	} > FLASH

	.data : { *(.data) } > RAM
	.bss : { *(.bss) } > RAM
}
