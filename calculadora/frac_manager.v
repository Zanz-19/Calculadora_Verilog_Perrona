module fraction_manager (
    input  wire        clk,
    input  wire        rst,
    input  wire        calc_pulse,     // pulso (1 ciclo) generado por debounce
    input  wire [1:0]  op_sel,         // 00 add, 01 sub, 10 mul2, 11 div2
    input  wire signed [7:0] acc_int,  // acumulador entero actual (signed)
    input  wire signed [7:0] data_in,  // entrada por switches (signed)
    output reg  [6:0]  frac_q,         // 0..99 centésimas (valor absoluto)
    output reg         frac_err        // 1 = resultado fuera de rango entero (-128..127)
);
    // temp wide signed to hold scaled values (en centésimas)
    reg signed [31:0] combined;
    reg signed [31:0] combined2;
    reg signed [31:0] data_scaled;
    integer mag;
    integer tmp_frac;
    integer tmp_int;

    // keep frac_q initial 0
    always @(posedge clk) begin
        if (rst) begin
            frac_q <= 7'd0;
            frac_err <= 1'b0;
        end else begin
            frac_err <= 1'b0; // default
            if (calc_pulse) begin
                // build combined = acc_int * 100 +/- frac_q (sign-aware)
                combined = acc_int * 100;
                if (acc_int < 0)
                    combined = combined - $signed(frac_q);
                else
                    combined = combined + $signed(frac_q);

                // scale data_in
                data_scaled = data_in * 100;

                // operation
                case (op_sel)
                    2'b00: combined2 = combined + data_scaled; // add
                    2'b01: combined2 = combined - data_scaled; // sub
                    2'b10: combined2 = combined <<< 1;         // mul2  (<<1)
                    2'b11: begin                              // div2 (arith)
                                // arithmetic divide: keep sign
                                combined2 = combined >>> 1;
                            end
                    default: combined2 = combined;
                endcase

                // compute next integer part and fraction (sign-aware)
                // Check integer overflow: integer_part = combined2 / 100
                tmp_int = combined2 / 100; // in Verilog signed division trunc toward zero
                // if tmp_int out of 8-bit signed range -> error, do not update frac
                if ((tmp_int > 127) || (tmp_int < -128)) begin
                    frac_err <= 1'b1;
                    // do not update frac_q (we keep previous frac)
                end else begin
                    // magnitude for fraction
                    mag = combined2;
                    if (mag < 0) mag = -mag;
                    tmp_frac = mag % 100; // 0..99
                    frac_q <= tmp_frac[6:0];
                end
            end
        end
    end
endmodule
