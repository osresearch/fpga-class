module top(
	output led_r,
	output led_g,
	output led_b
);
	wire clk;
	SB_HFOSC osc(1,1,clk); // 48 MHz oscillator

	reg [18:0] counter; // 19-bit counter
	reg [11:0] brightness = 10;
	reg [11:0] max_brightness = 200; // out of 4096 (2^12)
	reg dir = 0;
	
	// continuous assignment to all three LEDs
	wire led_on = counter[11:0] > brightness;
	assign led_r = led_on;
	assign led_g = led_on;
	assign led_b = led_on;

	always @(posedge clk) begin
		counter <= counter + 1;
		if (counter == 0)
			brightness <= brightness + (dir ? 1 : -1);
		if (brightness == 0)
			dir <= 1; // hit bottom, go up
		if (brightness == max_brightness)
			dir <= 0; // hit top, go down
	end
endmodule
