module UartTx

#(
	parameter CLKFREQ = 100_000_000,
	parameter BAUDRATE = 115200
)

(
	input clk,
	input reset,
	input txEnable,
	input [7:0] uartInByte,

	output uartTxBit,
	output uartTxDone
);

	wire countEnable;
	wire bpsClk;
	
	parameter bpsWIDTH = 14;
	BpsClkGen #(
		.CLKFREQ(CLKFREQ),
		.BAUDRATE(BAUDRATE),
		.bpsWIDTH(bpsWIDTH)
		)
		U_bpsClkGen (
			.clk(clk),
			.reset(reset),
			.countEnable(countEnable),
			.bpsClk(bpsClk)
			);
	
	reg isCount;
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			isCount <= 1'b0;
		else if (txEnable)
			begin
				if (bpsFrameNum == 4'd0)
					isCount <= 1'b1;
				else if (bpsFrameNum == 4'd11)
					isCount <= 1'b0;
			end
		else
			isCount <= 1'b0;
	end
	assign countEnable = isCount;
	
	reg [3:0] bpsFrameNum;// 波特率帧计数（状态机的状态）
	always @ (posedge clk or negedge reset)
	begin
		if (!reset)
			bpsFrameNum <= 1'd0;
		else if (bpsFrameNum == 4'd11)
			bpsFrameNum <= 1'd0;
		else if (txEnable)
			begin
				if (bpsClk)
					bpsFrameNum <= bpsFrameNum + 1'd1;
			end
		else
			bpsFrameNum <= 1'd0;
	end

	// uartTxDone 发送完毕信号，1为完成，且完成后1只持续一个时钟周期
	reg isDone;
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			isDone <= 1'b0;
		else if (bpsFrameNum == 4'd11)
			isDone <= 1'b1;
		else
			isDone <= 1'b0;
	end
	assign uartTxDone = isDone;
	
	// 发送数据
	reg uartTxReg;
	always @ (posedge clk or posedge reset)
	begin
		if (!reset)
			uartTxReg <= 1'b1;
		else if (txEnable)
			case (bpsFrameNum)
				4'd0: uartTxReg <= 1'b1; 
				4'd1: uartTxReg <= 1'b0; //begin
				4'd2: uartTxReg <= uartInByte[0];// data begin
				4'd3: uartTxReg <= uartInByte[1];
				4'd4: uartTxReg <= uartInByte[2];
				4'd5: uartTxReg <= uartInByte[3];
				4'd6: uartTxReg <= uartInByte[4];
				4'd7: uartTxReg <= uartInByte[5];
				4'd8: uartTxReg <= uartInByte[6];
				4'd9: uartTxReg <= uartInByte[7];// data end
				4'd10: uartTxReg <= 1'b1; //stop
				default: uartTxReg <= 1'b1;
			endcase
	end
	assign uartTxBit = uartTxReg;

endmodule
