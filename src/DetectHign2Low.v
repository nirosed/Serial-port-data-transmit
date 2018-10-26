module DetectHign2Low
(
	input clk,
	input reset,
	input signal,
	output high2LowSignal
);

	reg high2LowReg_1 = 1'b0;
	reg high2LowReg_2 = 1'b0;
	always @ (posedge clk or negedge reset)
	if (!reset)
		begin
			high2LowReg_1 <= 1'b0;
			high2LowReg_2 <= 1'b0;
		end
	else
		begin
			high2LowReg_1 <= signal;
			high2LowReg_2 <= high2LowReg_1;
		end

	assign high2LowSignal = high2LowReg_2 & !high2LowReg_1;
	
endmodule
