module DetectHign2Low_tb;

	reg clk;
	initial
		clk = 1'b0;
	always
		#5 clk = ~clk;

	reg reset;
	initial
	begin
		reset = 1'b1;
		#100 reset = 1'b0;
		#180 reset = 1'b1;
//		#20 $finish;
	end
	
	reg signal;
	initial
	begin
		signal = 1'b0;
		#1000 signal = 1'b1;
		#180 signal = 1'b0;
		#100 signal = 1'b1;
		#100 signal = 1'b0;
	end
	
	wire high2LowSignal;
	DetectHign2Low DetectHign2LowIns(
		.clk(clk),
		.reset(reset),
		.signal(signal),
		.high2LowSignal(high2LowSignal)
		);

endmodule
