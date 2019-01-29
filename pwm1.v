module top(
	output led_r // defined in PCF file
);
	wire clk;
	SB_HFOSC osc(1,1,clk); // 48 MHz oscillator

	reg [15:0] counter; // 16-bit counter
	reg [11:0] brightness = 50; // out of 4096 (2^12)

	always @(posedge clk) begin
		counter <= counter + 1;

		if (counter[11:0] > brightness)
			led_r <= 1; // turn LED off
		else
			led_r <= 0; // turn LED on
	end
endmodule
