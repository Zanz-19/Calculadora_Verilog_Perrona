module display_driver_top (
    input  wire [3:0] d4,
    input  wire [3:0] d3,
    input  wire [3:0] d2,
    input  wire [3:0] d1,
    input  wire [3:0] d0,
    output wire [6:0] disp4,
    output wire [6:0] disp3,
    output wire [6:0] disp2,
    output wire [6:0] disp1,
    output wire [6:0] disp0
);
    // asume displays activos LOW por defecto
    seven_seg_decoder #(.ACTIVE_LOW(1)) dec4(.digit(d4), .seg_out(disp4));
    seven_seg_decoder #(.ACTIVE_LOW(1)) dec3(.digit(d3), .seg_out(disp3));
    seven_seg_decoder #(.ACTIVE_LOW(1)) dec2(.digit(d2), .seg_out(disp2));
    seven_seg_decoder #(.ACTIVE_LOW(1)) dec1(.digit(d1), .seg_out(disp1));
    seven_seg_decoder #(.ACTIVE_LOW(1)) dec0(.digit(d0), .seg_out(disp0));
endmodule