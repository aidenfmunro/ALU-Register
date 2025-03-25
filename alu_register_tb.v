`timescale 1ns / 1ps

module alu_register_tb;
    parameter WIDTH = 8;
    parameter CLK_PERIOD = 10;

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
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    task test_operation;
        input [2:0] op;
        input [WIDTH-1:0] a;
        input [WIDTH-1:0] b;
        input [WIDTH-1:0] expected;
        begin
            opcode = op;
            first = a;
            second = b;
            #(2*CLK_PERIOD); // Ждем 2 цикла. Почему?
                             /*
                                "Результат операции, исполняемой в текущий такт, сохранен
                                 в регистре на следующий такт"
                             */
            if (result !== expected) begin
                $display("Ошибка: opcode=%b, first=%h, second=%h",
                        opcode, first, second);
                $display("Ожидалось: %h, Получено: %h", expected, result);
            end
        end
    endtask

    initial begin
        // Reset
        rst = 1;
        #(2*CLK_PERIOD);
        rst = 0;

        // Test NAND operation
        test_operation(3'b000, 8'b10101010, 8'b11001100, ~(8'b10101010 & 8'b11001100));

        // Test XOR operation
        test_operation(3'b001, 8'b11110000, 8'b10101010, (8'b11110000 ^ 8'b10101010));

        // Test ADD operation
        test_operation(3'b010, 8'd100, 8'd50, 8'd150);
        test_operation(3'b010, 8'b11111111, 8'b00000001, 8'b00000000);

        // Test ASR operation (arithmetic shift right)
        test_operation(3'b011, 8'b10011001, 2, 8'b11100110);
        test_operation(3'b011, 8'h80, 7, 8'hFF);

        // Test OR operation
        test_operation(3'b100, 8'b00110011, 8'b01010101, (8'b00110011 | 8'b01010101));

        // Test LSL operation (logical shift left)
        test_operation(3'b101, 8'b00001111, 2, 8'b00111100);

        // Test NOT operation
        test_operation(3'b110, 8'b01010101, 0, 8'b10101010);

        // Test LT operation (less than)
        test_operation(3'b111, 8'd50, 8'd100, 8'b00000001);
        test_operation(3'b111, 8'd100, 8'd50, 8'b00000000);

        // Test reset
        rst = 1;
        #(CLK_PERIOD/2);
        if (result !== 0) $display("Reset test failed");

        $display("All tests completed");
        $finish;
    end

endmodule
