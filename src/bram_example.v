module blk_mem_gen_0 #(
    parameter DATA_WIDTH = 1,
    parameter ADDR_WIDTH = 20
) (
    input clka,
    input clkb,
    input wea,
    input [ADDR_WIDTH-1:0] addra,
    input [ADDR_WIDTH-1:0] addrb,
    input [DATA_WIDTH-1:0] dina,
    output [DATA_WIDTH-1:0] doutb
);
    reg [DATA_WIDTH-1:0] mem [999999:0];
    reg [ADDR_WIDTH-1:0] reg1;
    // reg [ADDR_WIDTH-1:0] reg2;
    reg [DATA_WIDTH-1:0] doutb;

    initial begin
        for (integer i = 0; i<=999999 ; i+=1 ) begin
            mem[i]=0;
        end
    end

    always @(posedge clka) begin
        if (wea) begin
            mem[addra] <= dina;
        end
    end

    always @(posedge clkb) begin
        reg1<=addrb;
        doutb<=mem[reg1];
    end

    
endmodule