//使用20ns的时钟clk
module cnt_1s #(parameter CNT_1S_HALF_MAX = 25_000_000)
(
    input wire clk,
    input wire rstn,
    output clk_o
);

reg    [25:0] cnt_1s;
reg clk_o_reg;
//cnt_1s:1s计数器
assign clk_o = clk_o_reg;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        cnt_1s <= 26'b0;
    end else if (cnt_1s==CNT_1S_HALF_MAX-1) begin
        cnt_1s <= 0;
        clk_o_reg <= ~clk_o_reg;
    end else begin
        cnt_1s <= cnt_1s+1;
    end
end
//time每秒翻转一次。
endmodule