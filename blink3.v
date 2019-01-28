module top(
	output led_r // defined in PCF file
);
	wire clk;
	SB_HFOSC osc(1,1,clk); // 48 MHz oscillator

	reg [15:0] counter; // 16-bit counter
	reg [11:0] brightness = 4000; // out of 4096 (2^12)
	reg dir = 0;
	
	// continuous assignment
	assign led_r = counter[11:0] > brightness;

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
