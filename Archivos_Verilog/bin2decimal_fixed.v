module bin2decimal_fixed_combined (
    input  wire signed [7:0] acc_int, // entero -128..127
    input  wire [6:0]        frac,    // 0..99 (centésimas)
    output reg  [3:0] d4, // centenas
    output reg  [3:0] d3, // decenas
    output reg  [3:0] d2, // unidades
    output reg  [3:0] d1, // décimas
    output reg  [3:0] d0, // centésimas
    output reg         sign
);
    integer combined;
    integer mag;
    integer int_part;
    integer dec_part;

    always @(*) begin
        sign = acc_int[7];
        // recombine signed value: combined = acc_int*100 + sign * frac
        combined = acc_int * 100;
        if (acc_int < 0) combined = combined - frac;
        else combined = combined + frac;

        // magnitude for digit extraction
        if (combined < 0) mag = -combined;
        else mag = combined;

        int_part = mag / 100;  // integer part
        dec_part = mag % 100;  // 0..99

        d0 = dec_part % 10;           // centésimas
        d1 = (dec_part / 10) % 10;    // décimas
        d2 = int_part % 10;           // unidades
        d3 = (int_part / 10) % 10;    // decenas
        d4 = (int_part / 100) % 10;   // centenas
    end
endmodule
