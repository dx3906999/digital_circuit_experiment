`timescale 1ps/1ps

module test;
    
    reg  clk, rstn;
    reg key_in;
    wire mode;

    key_mode #(500) keym(clk, rstn, key_in, mode);
    always #1 clk = ~clk;
    initial begin
        clk <= 1;
        rstn <=0;
        key_in <=1;
        #1 rstn <=1;
    end

    initial begin
        #1000 key_in <=0;
        #600 key_in <=1;
        #1000 key_in <=0;
        #1200 key_in <=1;
        #200 key_in <=0;
        #600 key_in <=1;
        #1000 key_in <=0;
        #1200 key_in <=1;
        $finish;
    end

    initial begin
        $dumpfile("keywave.vcd");
        $dumpvars(0);
    end





endmodule

