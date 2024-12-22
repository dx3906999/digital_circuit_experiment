module key_mode #(parameter N = 1_000_000)(
    input clk,//系统时钟50MHz
    input rstn,//复位信号
    input key_in,//按键输入信号
    output mode//模式切换信号
);
    reg mode_reg;//位宽取决于N的值
    reg [20:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) cnt <= 24'd0; 
        else if (key_in == 1) cnt <= 0;
        else if (key_in==0) cnt<=(cnt<N)?cnt+1:cnt;
        end
    always@(posedge clk or negedge rstn) begin
        if (~rstn) mode_reg <=1'b0;
        else if (cnt == N-1) mode_reg <= ~mode_reg;
    end
    assign mode = mode_reg;
endmodule