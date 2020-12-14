`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * microwatt wrapper
 *
 *-------------------------------------------------------------
 */

`include "microwatt.v"

module user_proj_example (
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

   // microwatt signals
   wire 	ext_clk;
   reg	 	ext_rst_n; // active low
   wire         alt_reset;
   wire 	jtag_tck;
   wire 	jtag_tdi;
   wire 	jtag_tdo;
   wire 	jtag_tms;
   wire 	jtag_trst;
   wire 	spi_flash_clk;
   wire 	spi_flash_cs_n;
   wire         [3:0] spi_flash_i;
   wire         [3:0] spi_flash_o;
   wire         [3:0] spi_flash_oe;
   wire 	uart0_rxd;
   wire 	uart0_txd;
   wire 	uart1_rxd; // not hooked up
   wire 	uart1_txd; // not hooked up

   wire		oib_clk;
   wire	[7:0]	ob_data;
   wire		ob_pty;
   wire	[7:0]	ib_data;
   wire		ib_pty;

   assign uart1_rxd = 1; // not hooked up

   // Management engine wishbone slave is unused
   assign wbs_ack_o = 1'b0;
   assign wbs_dat_o = {32{1'b0}};

    // Assuming LA probes [65:64] are for controlling the microwatt clk & reset
   assign clk = (~la_oen[64]) ? la_data_in[64]: wb_clk_i;
   assign rst = (~la_oen[65]) ? la_data_in[65]: wb_rst_i;

   // LA probe 66 is to controll the reset address (RAM or FLASH)
   assign alt_reset = (~la_oen[66]) ? la_data_in[66]:  1'b0;

   // microwatt signals
   assign ext_clk = clk;

   reg [11:0] reset_counter;
   always @(posedge clk) begin
      if (rst) begin
         ext_rst_n <= 1'b0;
         reset_counter <= 0;
      end else if (reset_counter < 4095) begin
         ext_rst_n <= 1'b0;
         reset_counter <= reset_counter + 1'b1;
      end else begin
         ext_rst_n <= 1'b1;
      end
   end

   // JTAG pin 14-17

   // assign unused  = io_in[14];
   assign io_out[14] = jtag_tdo;
   assign io_oeb[14] = rst; // output

   assign jtag_tms = io_in[15];
   assign io_out[15] = 0; // don't care
   assign io_oeb[15] = 1; // input

   assign jtag_tck = io_in[16];
   assign io_out[16] = 0; // don't care
   assign io_oeb[16] = 1; // input

   assign jtag_tdi = io_in[17];
   assign io_out[17] = 0; // don't care
   assign io_oeb[17] = 1; // input

   assign jtag_trst = rst;

   // SPI
   // assign unused  = io_in[8];
   assign io_out[8] = spi_flash_cs_n; //(polarity??)
   assign io_oeb[8] = rst; // output

   // assign unused  = io_in[9];
   assign io_out[9] = spi_flash_clk;
   assign io_oeb[9] = rst; // output

   // Bi direction SPI pins
   assign io_out[10] = spi_flash_o[0];
   assign io_out[11] = spi_flash_o[1];
   assign io_out[12] = spi_flash_o[2];
   assign io_out[13] = spi_flash_o[3];

   assign io_oeb[10] = ~spi_flash_oe[0];
   assign io_oeb[11] = ~spi_flash_oe[1];
   assign io_oeb[12] = ~spi_flash_oe[2];
   assign io_oeb[13] = ~spi_flash_oe[3];

   assign spi_flash_i[0] = io_in[10];
   assign spi_flash_i[1] = io_in[11];
   assign spi_flash_i[2] = io_in[12];
   assign spi_flash_i[3] = io_in[13];

   // UART pin 5 6 as assigned
   assign uart0_rxd = io_in[5];
   assign io_out[5] = 0; // don't care
   assign io_oeb[5] = 1; // input

   // assign unused  = io_in[6];
   assign io_out[6] = uart0_txd;
   assign io_oeb[6] = rst;

   // bill's bus 18-36 -> 18-27 outputs, 28-36 inputs
   //assign =  in[18:27] = rst; don't care
   assign io_oeb[27:18] = {10{rst}}; // outputs
   assign io_out[18] = oib_clk;
   assign io_out[26:19] = ob_data;
   assign io_out[27] = ob_pty;

   assign io_out[36:28] = 0; // don't care
   assign io_oeb[36:28] = {9{1'b0}}; // input
   assign ib_data = io_in[35:28];
   assign ib_pty = io_in[36];

   microwatt
     microwatt_0(
	       .ext_clk(ext_clk),
	       .ext_rst(ext_rst_n),
	       .alt_reset(alt_reset),
	       .uart0_rxd(uart0_rxd),
	       .uart1_rxd(uart1_rxd),
	       .jtag_tck(jtag_tck),
	       .jtag_tdi(jtag_tdi),
	       .jtag_tms(jtag_tms),
	       .jtag_trst(jtag_trst),
	       .uart0_txd(uart0_txd),
	       .uart1_txd(uart1_txd),
	       .spi_flash_cs_n(spi_flash_cs_n),
	       .spi_flash_clk(spi_flash_clk),
	       .spi_flash_sdat_o(spi_flash_o),
	       .spi_flash_sdat_i(spi_flash_i),
	       .spi_flash_sdat_oe(spi_flash_oe),
	       .jtag_tdo(jtag_tdo),
	       .oib_clk(oib_clk),
	       .ob_data(ob_data),
	       .ob_pty(ob_pty),
	       .ib_data(ib_data),
		 .ib_pty(ib_pty));

endmodule

`default_nettype wire
