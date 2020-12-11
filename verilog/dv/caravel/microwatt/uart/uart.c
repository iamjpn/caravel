#include "../../defs.h"
#include "../../stub.c"

// --------------------------------------------------------

void main(void)
{
	// Configure All LA probes as inputs to the cpu
	reg_la0_ena = 0xFFFFFFFF;	// [31:0]
	reg_la1_ena = 0xFFFFFFFF;	// [63:32]
	reg_la2_ena = 0xFFFFFFFF;	// [95:64]
	reg_la3_ena = 0xFFFFFFFF;	// [127:96]

	// Set LA[65] as output to act as a reset pin for microwatt
	reg_la2_ena = 0xFFFFFFFD;

	// bits 28-31 as outputs to communicate to the tb
	reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;

	reg_mprj_datal = 0;

	// Signal to the tb that we are alive
	reg_mprj_datal = 0xA0000000;

	// Put microwatt into reset
	reg_la2_data = 0x00000002;

	// Set uart_rx to user input so microwatt can use it
	reg_mprj_io_5 = GPIO_MODE_USER_STD_INPUT_NOPULL;

	// Set uart_tx to user output so microwatt can use it
	reg_mprj_io_6 = GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Take microwatt out of reset
	reg_la2_data = 0x00000000;

	// Do nothing
	while (1)
		;
}
