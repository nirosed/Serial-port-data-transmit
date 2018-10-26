// ����BYTENUM���ֽڵ����ݣ������ݿ�ͷ����FF��Ϊ����ͷ
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
	parameter WIDTH = 8;//����8����������������254���ֽڵ����ݣ�Ŀǰ���ã��Ժ��������������޸�
	reg [WIDTH-1:0] fsmFrame;// �ֽ���������״̬����״̬��//�����״̬��ҲҪ�õ�λ���������ò���ûʲô����
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
	// ״̬����״̬Ϊ0-7��0Ϊ����ͷFF��1-7Ϊ���ݵ��ֽڣ��Ӹߵ���λ��

	reg isDone; //ȫ�������Ƿ��Ѿ�����
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
				8'd8:// �ر�UartTxʹ�ܶ˵�״̬
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
