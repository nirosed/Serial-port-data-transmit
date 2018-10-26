module BpsClkGen_tb;

	reg clk;
	initial
		clk = 1'b0;
	always
		#5 clk = ~clk;

	reg reset;
	initial
		reset = 1'b1;

	reg countEnable;
	initial
		begin
			countEnable = 1'b1;
			#50000 countEnable = 1'b0;
			#80000 countEnable = 1'b1;
		end

	wire bpsClk;
   	BpsClkGen ins(
		.clk(clk),
		.reset(reset),
		.countEnable(countEnable),
		.bpsClk(bpsClk)
		);
		 
endmodule

