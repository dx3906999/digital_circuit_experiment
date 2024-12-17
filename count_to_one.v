//使用20ns的时钟clk
module cnt_1s#(parameter CNT_1S_MAX = 10'd50_000_000)
(
	input wire clk,
	input wire rst_n,
	
	output reg time
);

reg	[25:0] cnt_1s;

//cnt_1s:1s计数器
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_1s <= 26'b0;	
        time <=	1'b0;
		end
	else if(cnt_1s >= CNT_1S_MAX) begin
		cnt_1s <= 26'b0;
        time <=	~time;
		end
	else
		cnt_1s <= cnt_1s + 1;
	end
//time每秒翻转一次。
end module