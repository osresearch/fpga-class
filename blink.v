module top(
	output led_r
);
	wire clk;
	SB_HFOSC osc(1,1,clk);

	reg [25:0] counter;

	always @(posedge clk) begin
		counter <= counter + 1;

		if (counter > 25'hA00000)
			led_r <= 1; // turn LED off
		else
			led_r <= 0; // turn LED on
	end
endmodule
