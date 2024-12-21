`timescale 1ns/1ps

module count_to_one_tb;
    reg clk;
	reg rst_n;
	
	wire clk_o;
    cnt_1s COUNT(
	    .clk(clk), 
	    .rstn(rst_n), 
	    .clk_o(clk_o)
    );

    initial begin
       clk <= 0; rst_n <= 0;
       #20 rst_n <= 1;
       forever #10 clk <= ~clk;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
        #500_000_000 $finish;
    end
endmodule