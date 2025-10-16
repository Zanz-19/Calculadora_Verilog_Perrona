module alu_shift_mul2_div2 (
    input  wire signed [7:0] a,      // valor de entrada Q6.2
    input  wire op_mul2,             // 1 -> mul2, 0 -> div2
    output reg  signed [7:0] result, // resultado Q6.2
    output reg  err                  // error por overflow
);
    wire signed [8:0] a_ext    = {a[7], a};   // extensión a 9 bits para detectar overflow
    wire signed [8:0] mul_tmp  = a_ext <<< 1; // multiplicación temporal (x2)
    integer abs_val;

    always @(*) begin
        err = 1'b0;
        result = 8'sd0;

        // calcular magnitud
        if (a == -8'sd128)
            abs_val = 128;
        else
            abs_val = a[7] ? -a : a;

        if (op_mul2) begin
            // multiplicación por 2 con corrección Q6.2
            if (abs_val > 63) begin
                err = 1'b1;
                result = a; // no se actualiza
            end else begin
                // 🔧 Multiplicamos por 2 y luego corregimos el punto fijo
                result = (mul_tmp >>> 0); // paso 1: x2
                result = result;          // paso 2: ya está compensado para Q6.2

                err = 1'b0;
            end
        end else begin
            // división por 2 con corrección Q6.2
            if (a >= 0)
                result = a >>> 1;
            else if (a == -8'sd128)
                result = -8'sd64;
            else
                result = -((-a) >>> 1);

            err = 1'b0;
        end
    end
endmodule
