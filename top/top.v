`timescale 1ns/1ns

module test;
    reg clk;
    reg rstn;
    reg timer;
    reg mode;
    wire [19:0] prime_num;

    eshelby_screen test(.clk(clk),.rstn(rstn),.timer(timer),.mode(mode),.prime_num(prime_num));

    initial begin
        clk = 1;
        rstn <= 0;
        timer <= 1;
        mode <= 1;
        #20 rstn <= 1;
    end

    always #10 clk = ~clk;
    always #25_000_00 timer = ~timer;

    initial begin
        #(50_000_00*10) $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0);
    end

endmodule