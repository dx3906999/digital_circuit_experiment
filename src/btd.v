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
            register = {register[22:0], binary[i]};

        end
    end
    assign output_data = register;
endmodule



