module op_decoder (
    input  wire [1:0] op_sel,
    output reg        op_add,
    output reg        op_sub,
    output reg        op_mul2,
    output reg        op_div2
);
			always @(*) begin
				 op_add = 0;
				 op_sub = 0;
				 op_mul2 = 0;
				 op_div2 = 0;

				 case (op_sel)
					  2'b00: op_add = 1; // 00 → Suma
					  2'b01: op_sub = 1; // 01 → Resta
					  2'b10: op_mul2 = 1; // 10 → Multiplica *2
					  2'b11: op_div2 = 1; // 11 → Divide /2
				 endcase
			end
endmodule
