module DetectLow2High
(
	input clk,
	input reset,
	input signal,
	output low2HighSignal
);

	reg low2HighReg_1 = 1'b1;
	reg low2HighReg_2 = 1'b1;
	always @ (posedge clk or negedge reset)
	if (!reset)
		begin
			low2HighReg_1 <= 1'b1;
			low2HighReg_2 <= 1'b1;
		end
	else
		begin
			low2HighReg_1 <= signal;
			low2HighReg_2 <= low2HighReg_1;
		end

	assign low2HighSignal = low2HighReg_1 & !low2HighReg_2;
	
endmodule
