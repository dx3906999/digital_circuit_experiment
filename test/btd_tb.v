wiremodule binary_to_decimal_tb;
    reg [19:0] binary;
    wire [23:0] decimal;

    // 实例化待测模块
    binary_to_decimal uut (
        .binary(binary),
        .output_data(decimal)
    );

    initial begin
        binary = 20'd1048575; #10; // 测试最大值
        $display("Binary: %d -> Decimal: %d", binary, decimal);
        $display("Binary: %b -> Decimal: %b", binary, decimal);
        binary = 20'd123456; #10; // 测试中间值
        $display("Binary: %d -> Decimal: %d", binary, decimal);
        $display("Binary: %b -> Decimal: %b", binary, decimal);
        binary = 20'd0; #10; // 测试最小值
        $display("Binary: %d -> Decimal: %d", binary, decimal);
        $display("Binary: %b -> Decimal: %b", binary, decimal);
        $stop;
    end
endmodule
