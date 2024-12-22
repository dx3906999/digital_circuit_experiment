module key_filter
#(
parameter CNT_MAX = 20'd999_999 //计数器计数最大值
)
(
input wire clk , //系统时钟50MHz
input wire rstn ,
input wire key_in , //按键输入信号

output reg state //key_flag为1时表示消抖后检测到按键被按下
//key_flag为0时表示没有检测到按键被按下
);


reg [19:0] cnt_20ms ; //计数器
reg key_flag;


//外部按键输入的值为低电平时，计数器开始计数
always@(posedge clk or negedge rstn)
if(rstn == 1'b0) cnt_20ms <= 20'b0;
else if(key_in == 1'b1) cnt_20ms <= 20'b0;
else if(cnt_20ms == CNT_MAX && key_in == 1'b0) cnt_20ms <= cnt_20ms;
else cnt_20ms <= cnt_20ms + 1'b1;

//key_flag:当计数满20ms后产生按键有效标志位
//且key_flag在cnt_20ms=999_999时拉高,维持一个时钟的高电平
always@(posedge clk or negedge rstn)
if(rstn == 1'b0) 
key_flag <= 1'b0;
else if(cnt_20ms == CNT_MAX - 1'b1)
key_flag <= 1'b1;
else
key_flag <= 1'b0;

reg key_flag_sync1, key_flag_sync2;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        key_flag_sync1 <= 0;
        key_flag_sync2 <= 0;
        state <= 0;
    end else begin
        key_flag_sync1 <= key_flag;  // 第一级同步
        key_flag_sync2 <= key_flag_sync1;  // 第二级同步

        if (key_flag_sync2 == 1 && key_flag_sync1 == 0) begin
            state <= ~state;  // 在上升沿时翻转state
        end
    end
end


endmodule