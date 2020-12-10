`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb
);
    wire clk;
    wire rst; // active high

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

   // microwatt signals
   wire 	ext_clk;
   wire 	ext_rst; // active low
   wire 	jtag_tck;
   wire 	jtag_tdi;
   wire 	jtag_tdo;
   wire 	jtag_tms;
   wire 	jtag_trst;
   wire 	spi_flash_clk;
   wire 	spi_flash_cs_n;
   wire 	spi_flash_hold_n;
   wire 	spi_flash_miso;
   wire 	spi_flash_mosi;
   wire 	spi_flash_wp_n;
   wire 	uart0_rxd;
   wire 	uart0_txd;
   wire 	uart1_rxd; // not hooked up
   wire 	uart1_txd; // not hooked up
   wire 	wb_la_ack; // not hooked up
   wire [31:0] wb_la_adr; // not hooked up
   wire 	 wb_la_cyc; // not hooked up
   wire [63:0]  wb_la_dat_i; // not hooked up
   wire [63:0] wb_la_dat_o; // not hooked up
   wire [7:0]  wb_la_sel; // not hooked up
   wire 	 wb_la_stall; // not hooked up
   wire 	 wb_la_stb; // not hooked up
   wire 	 wb_la_we; // not hooked up

    // Assuming LA probes [65:64] are for controlling the count clk & reset
   assign clk = (~la_oen[64]) ? la_data_in[64]: wb_clk_i;
   assign rst = (~la_oen[65]) ? la_data_in[65]: wb_rst_i;

   // microwatt signals
   assign ext_clk = clk;
   assign ext_rst = ~rst; // Polarity?


   // JTAG ping 16-29
   assign jtag_tck = io_in[16];
   assign io_out[16] = 0; // don't care
   assign io_oeb[16] = 1; // input

   assign jtag_tdi = io_in[17];
   assign io_out[17] = 0; // don't care
   assign io_oeb[17] = 1; // input

   // assign unused  = io_in[18];
   assign io_out[18] = jtag_tdo;
   assign io_oeb[18] = rst; // output

   assign jtag_tms = io_in[19];
   assign io_out[19] = 0; // don't care
   assign io_oeb[19] = 1; // input

   assign jtag_trst = 0; // don't use.


   // SPI
   // assign unused  = io_in[9];
   assign io_out[9] = spi_flash_clk;
   assign io_oeb[9] = rst; // output

   // assign unused  = io_in[8];
   assign io_out[8] = spi_flash_cs_n (polarity??);
   assign io_oeb[8] = rst; // output

   assign spi_flash_hold_n = io_in[12];
   assign io_out[12] = 0; // don't care
   assign io_oeb[12] = 1; // input

   assign spi_flash_miso = io_in[10];
   assign io_out[10] = 0; // don't care
   assign io_oeb[10] = 1; // input

   //   assign  = io_in[11];
   assign io_out[11] = spi_flash_mosi;
   assign io_oeb[11] = rst; // output

   assign spi_flash_wp_n = io_in[13];
   assign io_out[13] = 0; // don't care
   assign io_oeb[13] = 1; // input


   // UART pin 5 6 as assigned
   uart0_rxd = io_in[5];
   assign io_out[5] = 0; // don't care
   assign io_oeb[5] = 1; // input

   // assign unused  = io_in[6];
   assign io_out[6] = uart0_txd;
   assign io_oeb[6] = rst;

   // UART pin 20 21
   uart1_rxd = io_in[20];
   assign io_out[20] = 0; // don't care
   assign io_oeb[20] = 1; // input

   // assign unused  = io_in[21];
   assign io_out[21] = uart1_txd;
   assign io_oeb[21] = rst;

   toplevel
     microwatt(
	       .ext_clk(ext_clk),
	       .ext_rst(ext_rst),
	       .uart0_rxd(uart0_rxd),
	       .uart1_rxd(uart1_rxd),
	       .jtag_tck(jtag_tck),
	       .jtag_tdi(jtag_tdi),
	       .jtag_tms(jtag_tms),
	       .jtag_trst(jtag_trst),
	       .wb_la_dat_i(wb_la_dat_i),
	       .wb_la_ack(wb_la_ack),
	       .wb_la_stall(wb_la_stall),
	       .uart0_txd(uart0_txd),
	       .uart1_txd(uart1_txd),
	       .spi_flash_cs_n(spi_flash_cs_n),
	       .spi_flash_clk(spi_flash_clk),
	       .spi_flash_mosi(spi_flash_mosi),
	       .spi_flash_miso(spi_flash_miso),
	       .spi_flash_wp_n(spi_flash_wp_n),
	       .spi_flash_hold_n(spi_flash_hold_n),
	       .jtag_tdo(jtag_tdo),
	       .wb_la_adr(wb_la_adr),
	       .wb_la_dat_o(wb_la_dat_o),
	       .wb_la_cyc(wb_la_cyc),
	       .wb_la_stb(wb_la_stb),
	       .wb_la_sel(wb_la_sel),
	       .wb_la_we(wb_la_we));


endmodule

`default_nettype wire
