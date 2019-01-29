module top(
	output led_r // defined in PCF file
);
	wire clk;
	SB_HFOSC osc(1,1,clk); // 48 MHz oscillator

	reg [15:0] counter; // 16-bit counter
	reg [11:0] brightness = 4000; // out of 4096 (2^12)
	reg dir = 0;
	
	pwm pwm_r(clk, brightness, led_r);

	always @(posedge clk) begin
		counter <= counter + 1;
		if (counter == 0)
			brightness <= brightness + (dir ? 1 : -1);
		if (brightness == 0)
			dir <= 1; // hit bottom, go up
		if (brightness == 12'hFFF)
			dir <= 0; // hit top, go down
	end
endmodule

module pwm(
	input clk,
	input [WIDTH-1:0] brightness,
	output led
);
	parameter WIDTH = 12;
	reg [WIDTH-1:0] counter;
	assign led = counter > brightness;

	always @(posedge clk)
		counter <= counter + 1;
endmodule
