// 发送BYTENUM个字节的数据，在数据开头加上FF作为数据头
module DataSend
#(
	parameter CLKFREQ = 100_000_000,
	parameter BAUDRATE = 115200,
	parameter BYTENUM = 7
)

(
	input clk,
	input reset,
	input enable,
	input [8*BYTENUM-1:0] dataIn,
	
	output uartTx,
	output dataTxDone
);


	wire nextByteEnable;
	parameter WIDTH = 8;//等于8则可以最多连续发送254个字节的数据，目前够用，以后如果有问题可以修改
	reg [WIDTH-1:0] fsmFrame;// 字节数计数（状态机的状态）//后面的状态机也要用到位数，等于用参数没什么用了
	always @ (posedge clk or negedge reset)
	begin
		if (!reset)
			fsmFrame <= 1'd0;
		else if (fsmFrame == (BYTENUM + 2))
			fsmFrame <= 1'd0;
		else if (enable)
			begin
				if (nextByteEnable)
					fsmFrame <= fsmFrame + 1'd1;
			end
		else
			fsmFrame <= 1'd0;
	end
	// 状态机的状态为0-7，0为数据头FF，1-7为数据的字节（从高到低位）

	reg isDone; //全部数据是否已经发送
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			isDone <= 1'b0;
		else if (fsmFrame == (BYTENUM + 1))
			isDone <= 1'b1;
		else
			isDone <= 1'b0;
	end
	assign dataTxDone = isDone;


	reg [7:0] dataByte;
	reg txByteEnable;
	always @ (posedge clk or negedge reset)
	begin
		if (!reset)
			begin
				dataByte <= 8'bz;
				txByteEnable <= 1'b0;
			end
		else if (enable)
			case (fsmFrame)
				8'd0:
					begin
						dataByte <= 8'hFF;
						txByteEnable <= 1'b1;
					end
				8'd1:
					begin
						dataByte <= dataIn[55:48];
						txByteEnable <= 1'b1;
					end
				8'd2:
					begin
						dataByte <= dataIn[47:40];
						txByteEnable <= 1'b1;
					end
				8'd3:
					begin
						dataByte <= dataIn[39:32];
						txByteEnable <= 1'b1;
					end
				4'd4:
					begin
						dataByte <= dataIn[31:24];
						txByteEnable <= 1'b1;
					end
				8'd5:
					begin
						dataByte <= dataIn[23:16];
						txByteEnable <= 1'b1;
					end
				8'd6:
					begin
						dataByte <= dataIn[15:8];
						txByteEnable <= 1'b1;
					end
				8'd7:
					begin
						dataByte <= dataIn[7:0];
						txByteEnable <= 1'b1;
					end
				8'd8:// 关闭UartTx使能端的状态
					begin
						dataByte <= 8'hz;
						txByteEnable <= 1'b0;
					end
				default:
					begin
						dataByte <= 8'bz;
						txByteEnable <= 1'b0;
					end
			endcase
		else
			begin
				dataByte <= 8'bz;
				txByteEnable <= 1'b0;
			end
	end
	wire [7:0] uartInByte;
	assign uartInByte = dataByte;




	wire txEnable;
	wire uartTxDone;
	UartTx #(
		.CLKFREQ(CLKFREQ),
		.BAUDRATE(BAUDRATE)
		)
		uartTxIns (
			.clk(clk),
			.reset(reset),
			.txEnable(txEnable),
			.uartInByte(uartInByte),
			.uartTxBit(uartTx),
			.uartTxDone(uartTxDone)
			);
	assign nextByteEnable = uartTxDone;
	assign txEnable = txByteEnable;



endmodule
