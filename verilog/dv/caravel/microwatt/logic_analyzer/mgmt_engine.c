#include "../../defs.h"
#include "../../stub.c"

// --------------------------------------------------------

void main(void)
{
	// Set LA[65] as output to act as a reset pin for microwatt and
	// LA[66] as output to specify reset location (RAM or FLASH)
	reg_la2_ena = 0xFFFFFFF9;

	// Put microwatt into reset and tell it to fetch from flash
	reg_la2_data = 0x00000002 | 0x00000004;

	// Signal to the tb that we are alive
	reg_mprj_datal = 0x00000001;

	// Configure all other LA probes as inputs to the management SOC
	reg_la0_ena = 0xFFFFFFFF;	// [31:0]
	reg_la1_ena = 0xFFFFFFFF;	// [63:32]
	reg_la3_ena = 0xFFFFFFFF;	// [127:96]

	// external bus
	// 18-27 outputs
	reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;

	// 28-36 inputs
	reg_mprj_io_28 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_29 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_30 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_31 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_32 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_33 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_34 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_35 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
	reg_mprj_io_36 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;

	// bits 28-31 as outputs to communicate to the tb
	reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;

	// Set uart_rx to user input so microwatt can use it
	reg_mprj_io_5 = GPIO_MODE_USER_STD_INPUT_NOPULL;

	// Set uart_tx to user output so microwatt can use it
	reg_mprj_io_6 = GPIO_MODE_USER_STD_OUTPUT;

	// SPI
	reg_mprj_io_8 = GPIO_MODE_USER_STD_OUTPUT;		// CSB
	reg_mprj_io_9 = GPIO_MODE_USER_STD_OUTPUT;		// SCK
	reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;		// IO0/MOSI
	reg_mprj_io_11 = GPIO_MODE_USER_STD_INPUT_NOPULL;	// IO1/MISO

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Take microwatt out of reset
	reg_la2_data &= ~0x00000002;

	// Do nothing
	while (1)
		;
}
