module Aes #(parameter Nk = 4, Nr = 10) (
    input clk,
    input rst,
    input cs1,
    input cs2,
    input mosi,
    output misod,
	output misok,
    output [127:0] encrypted,
    output reg [127:0] decrypted
);

wire [127:0] data_in;
wire [Nk * 32 - 1:0] key;
wire [(Nr + 1) * 128 - 1:0] w;
wire ddone;
wire kdone;
wire expdone;

Spi #(.datasize(128))d (
    .clk(clk),
    .rst(rst),
    .cs(cs1),
    .miso(misod),
    .mosi(mosi),
    .done(ddone),
    .data(data_in)
);

KeyExpansion kex(
    .key_in(key),
    .key_out(w),
    .rst(rst),
    .en(kdone),
    .clk(clk),
    .done(expdone)
);

Spi #(.datasize(Nk * 32)) k  (
    .clk(clk),
    .rst(rst),
    .cs(cs2),
    .miso(misok),
    .mosi(mosi),
    .done(kdone),
    .data(key)
);

Cipher enc(
    .clk(clk),
    .data_in(data_in),
    .w(w),
    .rst(rst),
    .en(exdone),
    .data_out(encrypted)
);
    
endmodule