module key_mode #(parameter N = 1_000_000)(
    input clk,//系统时钟50MHz
    input rstn,//复位信号
    input key_in,//按键输入信号
    output mode//模式切换信号
);
    reg mode_reg;//位宽取决于N的值
    reg key_flag_sync1, key_flag_sync2;
    reg state;
    reg [20:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) cnt <= 24'd0; 
        else if (key_in == 1) cnt <= 0;
        else if (key_in==0) cnt<=(cnt<N)?cnt+1:cnt;
        end
    always@(posedge clk or negedge rstn) begin
        if (~rstn) mode_reg <=1'b0;
        else if (cnt == N-1) mode_reg <= 1'b1;//且cnt在999_999时拉高,维持一个时钟的高电平
        else mode_reg <= 1'b0;
    end
        
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            key_flag_sync1 <= 0;
            key_flag_sync2 <= 0;
            state <= 0;
        end else begin
            key_flag_sync1 <= mode_reg;  // 第一级同步
            key_flag_sync2 <= key_flag_sync1;  // 第二级同步

            if (key_flag_sync2 == 1 && key_flag_sync1 == 0) begin
                state <= ~state;  // 在上升沿时翻转state
            end
        end
    end
    assign mode = state;
endmodule