module top(
	output led_r
);
	wire clk;
	SB_HFOSC osc(1,1,clk);

	reg [25:0] counter;

	always @(posedge clk)
		counter <= counter + 1;

	assign led_r = counter[25];
endmodule
