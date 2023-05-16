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

Spi d(
    .clk(clk),
    .rst(rst),
    .cs(cs1),
    .miso(misod),
    .mosi(mosi),
    .data(data_in)
);

Spi k(
    .clk(clk),
    .rst(rst),
    .cs(cs2),
    .miso(misok),
    .mosi(mosi),
    .data(key)
);

Cipher enc(
    .clk(clk),
    .data_in(data_in),
    .rst(!cs1 || !cs2),
    .key(key),
    .data_out(encrypted)
);
    
endmodule