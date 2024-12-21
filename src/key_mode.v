module key_mode #(parameter N = 5_000_000)(
    input clk,
    input rstn,
    input key_in,
    output mode
);
    reg state;
    reg mode_reg;
    reg [23:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            mode_reg <=1'b1;
            cnt <= 24'd0;
            state <= 0;
        end else begin
            if (key_in==0) begin
                cnt<=(cnt+1<=N)?cnt+1:N;
            end else begin
                cnt<=(cnt==0)?0:cnt-1;
            end

            if (cnt == N) begin
                state <= 1;
            end else if (cnt <= N*9/10) begin
                    state <= 0;
            end
        end
    end
    always@(posedge state) begin
        mode_reg <= ~mode_reg;
    end
    assign mode = mode_reg;
endmodule