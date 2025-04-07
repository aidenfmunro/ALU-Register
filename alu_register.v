module alu_register #(parameter WIDTH = 8) (
    input wire                  clk_i,
    input wire                  rst_i,
    input wire [WIDTH-1:0]      first_i,
    input wire [WIDTH-1:0]      second_i,
    input wire [2:0]            opcode_i,
    output reg [WIDTH-1:0]      result_o
);

    always @(posedge clk_i) begin
        if (rst_i)
            result_o <= 0;
        else begin
            case (opcode_i)
                3'b000: result_o <= ~(first_i & second_i);
                3'b001: result_o <= first_i ^ second_i;
                3'b010: result_o <= first_i + second_i;
                3'b011: result_o <= $signed(first_i) >>> second_i;
                3'b100: result_o <= first_i | second_i;
                3'b101: result_o <= first_i << second_i;
                3'b110: result_o <=  ~first_i;
                3'b111: result_o <= (first_i < second_i) ? 1 : 0;

                default: result_o <= {WIDTH{1'b0}};
            endcase
        end
    end

endmodule




