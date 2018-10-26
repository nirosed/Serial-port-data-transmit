module BpsClkGen
// ����ʱ�ӡ������ʲ������ɴ��ڷ���ʱ�ӣ�
#(
	parameter CLKFREQ = 100_000_000,// in hz
	parameter BAUDRATE = 115200,
	parameter bpsWIDTH = 14
)

(
	input clk,
	input reset,
	input countEnable,//bpsCount����ʹ�ܣ�ֻ��ʹ��ʱ�ż�����ʹ��Ϊ0�����������
	output bpsClk//bpsʱ�Ӹߵ�ƽֻ����һ��ʱ������
);

	// �������趨
	reg [bpsWIDTH - 1:0] bps = CLKFREQ / BAUDRATE;
	
	// �����ʼ���
	reg [bpsWIDTH - 1:0] bpsCount = 1'd0;
	always @ (posedge clk or negedge reset)
	begin
		if (!reset)
			bpsCount <= 1'd0;
		else if (bpsCount == (bps - 1))
			bpsCount <= 1'd0;
		else if (countEnable)
			bpsCount <= bpsCount + 1'd1;
		else
			bpsCount <= 1'd0;
	end

	// ������ʹ��ʱ��
	wire [bpsWIDTH - 2:0] BPS_CLK_V = (bps >> 1);
	reg bpsClkEnable;
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			bpsClkEnable <= 1'd0;
		else if (bpsCount == BPS_CLK_V - 1)
			bpsClkEnable <= 1'd1;
		else
			bpsClkEnable <= 1'd0;
	end

	assign bpsClk = bpsClkEnable;
	
endmodule
