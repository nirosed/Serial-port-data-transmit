module BpsClkGen
// 按照时钟、波特率参数生成串口发送时钟，
#(
	parameter CLKFREQ = 100_000_000,// in hz
	parameter BAUDRATE = 115200,
	parameter bpsWIDTH = 14
)

(
	input clk,
	input reset,
	input countEnable,//bpsCount计数使能，只有使能时才计数，使能为0则计数器清零
	output bpsClk//bps时钟高电平只持续一个时钟周期
);

	// 波特率设定
	reg [bpsWIDTH - 1:0] bps = CLKFREQ / BAUDRATE;
	
	// 波特率计数
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

	// 波特率使能时钟
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
