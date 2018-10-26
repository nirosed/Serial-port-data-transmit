`timescale 1ns/1ps

module DataSend_tb;

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
		#300 reset = 1'b0;
		#2000 reset = 1'b1;
	end
	
	reg enable;
	initial
		enable = 1'b0;
	always
		#500900 enable = 1'b1;
		


	
	reg [55:0] dataIn;
	initial
		dataIn = 56'h0;
	always
		#5000000 dataIn = dataIn + 56'd20000;
		



	wire uartTx;
	wire dataTxDone;
	
	parameter CLKFREQ = 100_000_000;
	parameter BAUDRATE = 115200;
	DataSend#(
		.CLKFREQ(CLKFREQ),
		.BAUDRATE(BAUDRATE),
		.BYTENUM(7)
		)
		dataSendIns (
			.clk(clk),
			.reset(reset),
			.enable(enable),
			.dataIn(dataIn),
			.uartTx(uartTx),
			.dataTxDone(dataTxDone)
			);


	always @ (posedge clk)
		if (dataTxDone)
			enable = 1'b0;

endmodule
