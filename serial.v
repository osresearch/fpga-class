/** \file
 * Test the serial output to the FTDI cable.
 *
 * The SPI flash chip select *MUST* be pulled high to disable the
 * flash chip, otherwise they will both be driving the bus.
 *
 * This may interfere with programming; `iceprog -e 128` should erase enough
 * to make it compliant for re-programming
 *
 * The USB port will have to be cycled to get the FTDI to renumerate as
 * /dev/ttyUSB0.  Not sure what is going on with iceprog.
 */

`include "uart.v"

module top(
	output led_r,
	output led_g,
	output led_b,
	output serial_txd,
	input serial_rxd,
	output spi_cs,
	output gpio_2
);
	assign spi_cs = 1; // it is necessary to turn off the SPI flash chip
	wire debug0 = gpio_2;

	wire clk_48;
	wire reset = 0;
	SB_HFOSC u_hfosc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk_48)
	);

	assign led_g = 1;
	assign led_b = serial_rxd; // idles high

	// generate a 1 MHz serial clock from the 48 MHz clock
	reg [5:0] divide_counter;
	reg clk_1;
	always @(posedge clk_48)
	begin
		if (divide_counter == 48-1)
		begin
			clk_1 <= 1;
			divide_counter <= 0;
		end else
		begin
			clk_1 <= 0;
			divide_counter <= divide_counter + 1;
		end
	end

	reg [7:0] uart_txd;
	reg uart_txd_strobe;
	wire uart_txd_ready;

	uart_tx txd(
		.clk(clk_48),
		.reset(reset),
		.baud_clk(clk_1),
		.serial_txd(serial_txd),
		.ready(uart_txd_ready),
		.data(uart_txd),
		.data_strobe(uart_txd_strobe)
	);

	assign debug0 = serial_txd;
	reg [4:0] byte_counter;

	always @(posedge clk_48)
	begin
		led_r <= 1;
		uart_txd_strobe <= 0;

		if (uart_txd_ready && !uart_txd_strobe)
		begin
			// ready to send a new byte
			uart_txd_strobe <= 1;

			if (byte_counter == 0)
				uart_txd <= "\r";
			else
			if (byte_counter == 1)
				uart_txd <= "\n";
			else
				uart_txd <= "A" + byte_counter - 2;
			byte_counter <= byte_counter + 1;
			led_r <= 0;
		end
	end
endmodule
