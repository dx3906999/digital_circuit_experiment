module binary_to_decimal #(parameter N = 20)
(
    input [N-1:0] binary,
    output [23:0] output_data
    );

    reg [23:0] register;

integer i;
integer j;
    always @(binary) begin
        register = 24'd0;
        
        for (i = 19;i >= 0; i = i-1) begin
            for (j = 0; j <= 5; j = j+1) begin
                if (register[(4*j)+3-:4]>= 4'b0101) register[(4*j)+3-:4] = register[(4*j)+3-:4] + 4'b0011;
            end
            for (j = 1; j <= 5; j = j+1) begin
                register[(4*j)+3-:4] = {register[(4*j-1)+3-:2], register[(4*j-1)+1 -:1]};
            end
            register[3:0] = {register[2:0], binary[i]};//使用阻塞赋值

        end
    end
    assign output_data = register;
endmodule



