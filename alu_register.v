module alu_register #(parameter WIDTH = 8) (
    input wire                  clk_i,
    input wire                  rst_i,
    input wire [WIDTH-1:0]      first_i,
    input wire [WIDTH-1:0]      second_i,
    input wire [2:0]            opcode_i,
    output reg [WIDTH-1:0]      result_o
);
    reg [WIDTH-1:0] result_reg;

    always @(posedge clk_i) begin
        if (rst_i)
            result_reg <= 0;
        else begin
            case (opcode_i)
                3'b000: result_reg <= ~(first_i & second_i);
                3'b001: result_reg <= first_i ^ second_i;
                3'b010: result_reg <= first_i + second_i;
                3'b011: result_reg <= $signed(first_i) >>> second_i;
                3'b100: result_reg <= first_i | second_i;
                3'b101: result_reg <= first_i << second_i;
                3'b110: result_reg <=  ~first_i;
                3'b111: result_reg <= (first_i < second_i) ? 1 : 0;

                default: result_reg <= {WIDTH{1'b0}};
            endcase
        end
    end

    always @(posedge clk_i) begin
        result_o <= result_reg;
    end

endmodule




