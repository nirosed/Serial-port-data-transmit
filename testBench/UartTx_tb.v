module UartTx_tb;

	reg clk;
	initial
		clk = 1'b0;
	always
		#5 clk = ~clk;

	reg reset;
	initial
	begin
		reset = 1'b0;
		#50 reset = 1'b1;
		#34567 reset = 1'b0;
		#20 reset = 1'b1;
		#300000 reset = 1'b0;
		#2000 reset = 1'b1;
	end
	
	reg txEnable;
	initial
		txEnable = 1'b0;
	always
		#300000 txEnable = ~txEnable;
	
	reg[7:0] uartInByte;
	initial
		uartInByte = 8'h72;

	wire uartTxBit;
	wire uartTxDone;
	UartTx UartTxIns(
		.clk(clk),
		.reset(reset),
		.txEnable(txEnable),
		.uartInByte(uartInByte),
		.uartTxBit(uartTxBit),
		.uartTxDone(uartTxDone)
		);

endmodule
