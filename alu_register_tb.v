`timescale 1ns / 1ps

module alu_register_tb;
    parameter WIDTH = 8;

    reg clk;
    reg rst;
    reg [WIDTH-1:0] first;
    reg [WIDTH-1:0] second;
    reg [2:0] opcode;
    wire [WIDTH-1:0] result;

    // Instantiate the unit under test
    alu_register #(.WIDTH(WIDTH)) uut (
        .clk_i(clk),
        .rst_i(rst),
        .first_i(first),
        .second_i(second),
        .opcode_i(opcode),
        .result_o(result)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst = 1;
        first = 0;
        second = 0;
        opcode = 0;

        // Reset the module
        #10;
        rst = 0;

        // Test NAND operation
        opcode = 3'b000;
        first = 8'b10101010;
        second = 8'b11001100;

        #20;  // Wait 2 cycles. Why?
              /*
                "Результат операции, исполняемой в текущий такт, сохранен
                 в регистре на следующий такт"
              */

        if (result !== ~(8'b10101010 & 8'b11001100)) $display("NAND test failed");

        // Test XOR operation
        opcode = 3'b001;
        first = 8'b11110000;
        second = 8'b10101010;
        #20;
        if (result !== (8'b11110000 ^ 8'b10101010)) $display("XOR test failed");

        // Test ADD operation
        opcode = 3'b010;
        first = 8'd100;
        second = 8'd50;
        #20;
        if (result !== 8'd150) $display("ADD test failed");

        // Test ASR operation (arithmetic shift right)
        opcode = 3'b011;
        first = 8'b10011001; // -103 in 2's complement
        second = 2;
        #20;
        if (result !== 8'b11100110) $display("ASR test failed"); // -26 after shift

        // Test OR operation
        opcode = 3'b100;
        first = 8'b00110011;
        second = 8'b01010101;
        #20;
        if (result !== (8'b00110011 | 8'b01010101)) $display("OR test failed");

        // Test LSL operation (logical shift left)
        opcode = 3'b101;
        first = 8'b00001111;
        second = 2;
        #20;
        if (result !== 8'b00111100) $display("LSL test failed");

        // Test NOT operation
        opcode = 3'b110;
        first = 8'b01010101;
        #20;
        if (result !== 8'b10101010) $display("NOT test failed");

        // Test LT operation (less than)
        opcode = 3'b111;
        first = 8'd50;
        second = 8'd100;
        #20;
        if (result !== 8'b00000001) $display("LT test 1 failed");

        first = 8'd100;
        second = 8'd50;
        #20;
        if (result !== 8'b00000000) $display("LT test 2 failed");

        // Test reset
        rst = 1;
        #20;
        if (result !== 0) $display("Reset test failed");

        $display("All tests completed");
        $finish;
    end

endmodule
